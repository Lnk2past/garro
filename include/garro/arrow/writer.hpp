#pragma once

#include <arrow/api.h>
#include <arrow/io/api.h>
#include <arrow/ipc/api.h>

#include <filesystem>
#include <memory>
#include <string>
#include <tuple>
#include <vector>

#include "garro/column.hpp"

namespace garro::feather
{
    template <typename... Columns>
    class Writer
    {
        using ColumnTypes = std::tuple<Columns...>;
        using ValueTuple = std::tuple<typename Columns::type...>;

    public:
        Writer(Columns &&...columns_) : columns(std::forward_as_tuple(columns_...))
        {
            set_schema(columns_...);
            init_storage();
        }

        auto open(const std::filesystem::path &path)
        {
            file_path = path;

            auto result = arrow::io::FileOutputStream::Open(file_path.string());
            if (!result.ok())
            {
                throw std::runtime_error("Failed to open output stream for: " + file_path.string());
            }
            output_stream = *result;

            auto writer_result = arrow::ipc::MakeFileWriter(output_stream, schema);
            if (!writer_result.ok())
            {
                throw std::runtime_error("Failed to create Arrow file writer");
            }
            file_writer = *writer_result;
        }

        auto close() -> void
        {
            write_buffered_rows();
            [[maybe_unused]] auto a = file_writer->Close();
            [[maybe_unused]] auto b = output_stream->Close();
        }

        template <typename First, typename... Rest>
        auto buffer(First &&first, Rest &&...rest) -> void
        {
            store_row(std::forward<First>(first), std::forward<Rest>(rest)...);
        }

        auto flush() -> void
        {
            // No-op: Arrow data is written on `close()`
        }

        auto write(typename Columns::type... values) -> void
        {
            buffer(std::forward<typename Columns::type>(values)...);
            flush();
        }

    private:
        ColumnTypes columns;
        std::shared_ptr<arrow::Schema> schema;
        std::filesystem::path file_path;

        std::shared_ptr<arrow::io::FileOutputStream> output_stream;
        std::shared_ptr<arrow::ipc::RecordBatchWriter> file_writer;

        // Internal storage
        std::tuple<std::vector<typename Columns::type>...> data_vectors;

        template <typename First, typename... Rest>
        auto set_schema(First &&first, Rest &&...rest)
        {
            std::vector<std::shared_ptr<arrow::Field>> fields = {
                arrow::field(first.name, infer_arrow_type<typename std::decay_t<First>::type>()),
                arrow::field(rest.name, infer_arrow_type<typename std::decay_t<decltype(rest)>::type>())...};
            schema = std::make_shared<arrow::Schema>(fields);
        }

        void init_storage()
        {
            data_vectors = std::tuple<std::vector<typename Columns::type>...>{};
        }

        void store_row(typename Columns::type... values)
        {
            store_row_impl(std::index_sequence_for<Columns...>{}, values...);
        }

        template <std::size_t... Is>
        void store_row_impl(std::index_sequence<Is...>, typename Columns::type... values)
        {
            ((std::get<Is>(data_vectors).push_back(values)), ...);
        }

        void write_buffered_rows()
        {
            std::vector<std::shared_ptr<arrow::Array>> arrays;
            build_arrays(arrays);

            int64_t num_rows = std::get<0>(data_vectors).size();
            auto batch = arrow::RecordBatch::Make(schema, num_rows, arrays);

            [[maybe_unused]] auto a = file_writer->WriteRecordBatch(*batch);
        }

        void write_arrow_file()
        {
            std::vector<std::shared_ptr<arrow::Array>> arrays;
            build_arrays(arrays);

            int64_t num_rows = std::get<0>(data_vectors).size();
            auto batch = arrow::RecordBatch::Make(schema, num_rows, arrays);

            auto output_res = arrow::io::FileOutputStream::Open(file_path.string());
            if (!output_res.ok())
                throw std::runtime_error("Failed to open file: " + file_path.string());

            auto file_writer_res = arrow::ipc::MakeFileWriter(*output_res, schema);
            if (!file_writer_res.ok())
                throw std::runtime_error("Failed to create Arrow file writer");

            auto file_writer = *file_writer_res;
            [[maybe_unused]] auto write_status = file_writer->WriteRecordBatch(*batch);
            [[maybe_unused]] auto close_status = file_writer->Close();
            [[maybe_unused]] auto ostatus = output_res.ValueOrDie()->Close();
        }

        void build_arrays(std::vector<std::shared_ptr<arrow::Array>> &out)
        {
            build_arrays_impl(out, std::index_sequence_for<Columns...>{});
        }

        template <std::size_t... Is>
        void build_arrays_impl(std::vector<std::shared_ptr<arrow::Array>> &out, std::index_sequence<Is...>)
        {
            (..., (out.push_back(build_array(std::get<Is>(data_vectors)))));
        }

        template <typename T>
        auto build_array(const std::vector<T> &data) -> std::shared_ptr<arrow::Array>
        {
            using BuilderType = typename arrow::CTypeTraits<T>::BuilderType;
            BuilderType builder;
            [[maybe_unused]] auto a = builder.AppendValues(data);
            std::shared_ptr<arrow::Array> array;
            [[maybe_unused]] auto b = builder.Finish(&array);
            return array;
        }

        template <typename T>
        static auto infer_arrow_type() -> std::shared_ptr<arrow::DataType>
        {
            if constexpr (std::is_same_v<T, int32_t>)
                return arrow::int32();
            else if constexpr (std::is_same_v<T, int64_t>)
                return arrow::int64();
            else if constexpr (std::is_same_v<T, float>)
                return arrow::float32();
            else if constexpr (std::is_same_v<T, double>)
                return arrow::float64();
            else if constexpr (std::is_same_v<T, std::string>)
                return arrow::utf8();
            else
                static_assert(sizeof(T) == 0, "Unsupported Arrow type");
        }
    };
}
