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
        static constexpr auto ext = std::string_view{".arrow"};

        Writer(Columns &&...columns_) : columns(std::forward_as_tuple(columns_...))
        {
            set_schema((std::forward<Columns>(columns_))...);
        }

        ~Writer()
        {
            close();
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

            auto writer_result = arrow::ipc::MakeStreamWriter(output_stream, schema);
            if (!writer_result.ok())
            {
                throw std::runtime_error("Failed to create Arrow file writer");
            }
            file_writer = *writer_result;
        }

        auto close() -> void
        {
            flush();
            [[maybe_unused]] auto a = file_writer->Close();
            [[maybe_unused]] auto b = output_stream->Close();
        }

        template <typename... T>
        auto buffer(T &&...values) -> void
        {
            store_row_impl(std::index_sequence_for<Columns...>{}, values...);
        }

        auto flush() -> void
        {
            std::vector<std::shared_ptr<arrow::Array>> arrays;
            build_arrays(arrays);

            int64_t num_rows = std::get<0>(data_vectors).size();
            auto batch = arrow::RecordBatch::Make(schema, num_rows, arrays);

            [[maybe_unused]] auto a = file_writer->WriteRecordBatch(*batch);

            std::apply([](auto &...data)
                       { (data.clear(), ...); }, data_vectors);
        }

        template <typename... T>
        auto write(T &&...values) -> void
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

        auto set_schema(Columns &&...columns)
        {
            std::vector<std::shared_ptr<arrow::Field>> fields = {
                arrow::field(std::string(columns.name), arrow::CTypeTraits<typename std::decay_t<decltype(columns)>::type>::type_singleton())...};
            schema = std::make_shared<arrow::Schema>(fields);
        }

        template <std::size_t... Is>
        void store_row_impl(std::index_sequence<Is...>, typename Columns::type... values)
        {
            ((std::get<Is>(data_vectors).push_back(values)), ...);
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
    };
}
