#pragma once

#include <arrow/api.h>
#include <arrow/io/api.h>
#include <arrow/ipc/api.h>

#include "garro/arrow/buffer_policy.hpp"
#include "garro/arrow/column.hpp"

#include <filesystem>
#include <memory>
#include <string>
#include <tuple>
#include <type_traits>
#include <utility>
#include <vector>

namespace garro::feather
{

template <typename BufferPolicy, typename... Columns> class Writer
{
    using ColumnTuple = std::tuple<std::decay_t<Columns>...>;
    static constexpr std::size_t N = sizeof...(Columns);

  public:
    static constexpr auto ext = std::string_view{".arrow"};

    template <typename BP>
        requires(!IsColumn<BP>)
    Writer(BP bp, Columns... cols)
        : buffer_policy(std::move(bp)), columns(std::move(cols)...),
          schema(make_schema(std::index_sequence_for<Columns...>{}))
    {
    }

    Writer(Columns... cols)
        : buffer_policy(buffer_policies::Buffered{}), columns(std::move(cols)...),
          schema(make_schema(std::index_sequence_for<Columns...>{}))
    {
    }

    ~Writer()
    {
        close();
    }

    auto open(const std::filesystem::path &path) -> void
    {
        file_path = path;
        auto status = [&]() {
            auto write_options = arrow::ipc::IpcWriteOptions::Defaults();
            ARROW_ASSIGN_OR_RAISE(output_stream, arrow::io::FileOutputStream::Open(file_path.string()));
            ARROW_ASSIGN_OR_RAISE(file_writer, arrow::ipc::MakeFileWriter(output_stream.get(), schema, write_options));
            return arrow::Status::OK();
        }();
        if (status != arrow::Status::OK())
        {
            throw std::runtime_error("File not opened");
        }
    }

    auto close() -> void
    {
        if (file_writer)
        {
            flush();
            std::ignore = file_writer->Close();
            file_writer.reset();
        }
        if (output_stream)
        {
            std::ignore = output_stream->Close();
            output_stream.reset();
        }
    }

    template <typename... T> auto buffer(T &&...values) -> void
    {
        buffer_impl(std::make_index_sequence<N>{}, std::forward<T>(values)...);
    }

    auto flush() -> void
    {
        if (!file_writer)
        {
            throw std::runtime_error("File writer not opened");
        }

        arrays.clear();
        arrays.reserve(N);

        std::apply([&](auto &...elems) { (arrays.push_back(elems.build()), ...); }, columns);
        const auto num_rows = arrays[0]->length();
        if (num_rows == 0)
        {
            return;
        }

        auto batch = arrow::RecordBatch::Make(schema, num_rows, arrays);
        std::ignore = file_writer->WriteRecordBatch(*batch);

        std::apply([](auto &...elems) { (elems.clear(), ...); }, columns);
        arrays.clear();
    }

    template <typename... T> auto write(T &&...values) -> void
    {
        buffer(std::forward<T>(values)...);
        if (!buffer_policy(*this))
        {
            flush();
        }
    }

    auto get_rows_buffered() const -> std::uint32_t
    {
        return std::get<0>(columns).get_buffered_count();
    }

  private:
    BufferPolicy buffer_policy;
    ColumnTuple columns;
    std::shared_ptr<arrow::Schema> schema;
    std::filesystem::path file_path;

    std::shared_ptr<arrow::io::FileOutputStream> output_stream;
    std::shared_ptr<arrow::ipc::RecordBatchWriter> file_writer;
    std::vector<std::shared_ptr<arrow::Array>> arrays{};

    template <std::size_t... Is> auto make_schema(std::index_sequence<Is...>) -> std::shared_ptr<arrow::Schema>
    {
        arrow::FieldVector fields{arrow::field(
            std::string(std::get<Is>(columns).name),
            arrow::CTypeTraits<typename std::decay_t<decltype(std::get<Is>(columns))>::type>::type_singleton())...};
        return std::make_shared<arrow::Schema>(std::move(fields));
    }

    template <std::size_t... Is, typename... T> auto buffer_impl(std::index_sequence<Is...>, T &&...values) -> void
    {
        (std::get<Is>(columns).buffer(std::forward<T>(values)), ...);
    }
};

// Guide 1: Only matches if the first argument is NOT a column.
template <typename T, typename... Args>
    requires(!IsColumn<std::decay_t<T>>)
Writer(T, Args...) -> Writer<T, Args...>;

// Guide 2: Matches if EVERYTHING passed is a column.
template <typename... Args>
    requires(IsColumn<std::decay_t<Args>> && ...)
Writer(Args...) -> Writer<buffer_policies::Buffered, Args...>;
} // namespace garro::feather
