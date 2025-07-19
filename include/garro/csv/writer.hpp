#pragma once

#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>
#include <tuple>
#include <vector>

#include "garro/column.hpp"

namespace garro::csv
{

    template <typename... Columns>
    class Writer
    {
        using ColumnTypes = std::tuple<Columns...>;
        using ValueTuple = std::tuple<typename Columns::type...>;

    public:
        static constexpr auto ext = std::string_view{".csv"};

        Writer(Columns &&...cols) : columns_(std::forward_as_tuple(cols...)) {}

        ~Writer()
        {
            close();
        }

        void open(const std::filesystem::path &path)
        {
            ofs_.open(path);
            if (!ofs_)
            {
                throw std::runtime_error("Failed to open file: " + path.string());
            }
            write_header();
        }

        void close()
        {
            ofs_.close();
        }

        template <typename... T>
        void buffer(T &&...values)
        {
            ofs_ << serialize_row(std::forward<T>(values)...) << "\n";
        }

        void flush()
        {
            ofs_ << std::flush;
        }

        template <typename... T>
        void write(T &&...values)
        {
            buffer(std::forward<T>(values)...);
            flush();
        }

    private:
        std::ofstream ofs_;
        ColumnTypes columns_;

        void write_header()
        {
            std::ostringstream ss;
            write_header_impl(ss, std::index_sequence_for<Columns...>{});
            ofs_ << ss.str() << "\n";
        }

        template <std::size_t... Is>
        void write_header_impl(std::ostringstream &ss, std::index_sequence<Is...>)
        {
            ((ss << (Is == 0 ? "" : ",") << std::get<Is>(columns_).name), ...);
        }

        template <typename... T>
        std::string serialize_row(T &&...values)
        {
            std::ostringstream ss;
            serialize_row_impl(ss, std::forward<T>(values)...);
            return ss.str();
        }

        template <typename First, typename... Rest>
        void serialize_row_impl(std::ostringstream &ss, First &&first, Rest &&...rest)
        {
            ss << format_value(std::forward<First>(first));
            ((ss << "," << format_value(std::forward<Rest>(rest))), ...);
        }

        template <typename T>
        std::string format_value(const T &value)
        {
            return std::to_string(value);
        }

        std::string format_value(const std::string &value)
        {
            return "\"" + value + "\""; // CSV-safe quoting
        }

        const char *format_value(const char *value)
        {
            return value;
        }
    };

} // namespace garro::csv
