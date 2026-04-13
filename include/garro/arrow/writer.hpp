#pragma once

#include <arrow/api.h>
#include <arrow/io/api.h>
#include <arrow/ipc/api.h>

#include "garro/arrow/column.hpp"
#include "garro/buffer_policy.hpp"

#include <filesystem>
#include <functional>
#include <memory>
#include <print>
#include <string>
#include <tuple>
#include <type_traits>
#include <utility>
#include <vector>

namespace garro::feather
{

template <typename... Columns> class Writer
{
    using ColumnTuple = std::tuple<std::decay_t<Columns>...>;
    static constexpr std::size_t N = sizeof...(Columns);

  public:
    static constexpr auto ext = std::string_view{".arrow"};

    template <typename BP>
        requires(std::invocable<BP, Writer> && !ColumnT<BP>)
    Writer(BP &&bp, Columns... cols) : columns(std::move(cols)...), buffer_policy(bp)
    {
    }

    Writer(Columns... cols) : columns(std::move(cols)...), buffer_policy(buffer_policies::Buffered{})
    {
    }

    ~Writer()
    {
        close();
    }

    auto open(const std::filesystem::path &path) -> void
    {
        auto status = [&]() {
            auto write_options = arrow::ipc::IpcWriteOptions::Defaults();
            ARROW_ASSIGN_OR_RAISE(output_stream, arrow::io::FileOutputStream::Open(path.string()));
            ARROW_ASSIGN_OR_RAISE(file_writer, arrow::ipc::MakeFileWriter(output_stream.get(), schema, write_options));
            return arrow::Status::OK();
        }();
        if (status != arrow::Status::OK())
        {
            throw std::runtime_error("File not opened");
        }
    }

    auto close() noexcept -> void
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
            std::println("File writer not opened");
            return;
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

    template <typename BP>
        requires(std::invocable<BP, Writer>)
    auto set_buffer_policy(BP &&bp)
    {
        buffer_policy = std::move(bp);
    }

    auto get_rows_buffered() const -> std::int64_t
    {
        return std::get<0>(columns).get_buffered_count();
    }

  private:
    ColumnTuple columns;
    std::shared_ptr<arrow::Schema> schema = make_schema(std::index_sequence_for<Columns...>{});
    std::function<bool(const Writer &)> buffer_policy;

    std::shared_ptr<arrow::io::FileOutputStream> output_stream{};
    std::shared_ptr<arrow::ipc::RecordBatchWriter> file_writer{};
    std::vector<std::shared_ptr<arrow::Array>> arrays{};

    template <std::size_t... Is> auto make_schema(std::index_sequence<Is...>) -> std::shared_ptr<arrow::Schema>
    {
        auto fields = arrow::FieldVector{arrow::field(
            std::string(std::get<Is>(columns).name),
            arrow::CTypeTraits<typename std::decay_t<decltype(std::get<Is>(columns))>::type>::type_singleton())...};
        return std::make_shared<arrow::Schema>(std::move(fields));
    }

    template <std::size_t... Is, typename... T> auto buffer_impl(std::index_sequence<Is...>, T &&...values) -> void
    {
        (std::get<Is>(columns).buffer(std::forward<T>(values)), ...);
    }
};

} // namespace garro::feather
