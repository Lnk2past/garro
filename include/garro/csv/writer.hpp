#pragma once

#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <tuple>

#include "garro/column.hpp"

namespace garro::csv
{
    template <typename... Columns>
    class Writer
    {
        using ColumnTypes = std::tuple<Columns...>;

    public:
        Writer(Columns &&...columns_) : columns(std::forward_as_tuple(columns_...))
        {
            set_header(columns_...);
        }

        auto open(const std::filesystem::path &path)
        {

            ofs.open(path);
            ofs << header << std::endl;
        }

        auto close() -> void
        {
            ofs.close();
        }

        template <typename First, typename... Rest>
        auto buffer(First &&first, Rest &&...rest) -> void
        {
            ofs << first;
            ((ofs << "," << rest), ...);
        }

        auto flush() -> void
        {
            ofs << std::flush;
        }

        auto write(Columns::type... values) -> void
        {
            buffer(values...);
            flush();
        }

    private:
        template <typename First, typename... Rest>
        auto set_header(First &&first, Rest &&...rest)
        {
            auto ss = std::stringstream{};
            ss << first.name;
            ((ss << "," << rest.name), ...);
            header = ss.str();
        }

        ColumnTypes columns;
        std::ofstream ofs{};
        std::string header{};
    };
}
