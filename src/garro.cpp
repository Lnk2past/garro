#include "garro/garro.hpp"

#include <fmt/format.h>
#include <fmt/ranges.h>

#include <fstream>
#include <ranges>
#include <vector>

#include "garro/garro.hpp"

auto main(int, char **) -> int
{
    auto csv_writer = garro::csv::Writer(
        garro::Column<int>("a"),
        garro::Column<int>("b"),
        garro::Column<int>("c"));

    csv_writer.open(std::filesystem::path{"test.csv"});
    csv_writer.write(1, 2, 3);

    auto arrow_writer = garro::feather::Writer(
        garro::Column<int>("a"),
        garro::Column<int>("b"),
        garro::Column<int>("c"));

    arrow_writer.open(std::filesystem::path{"test.arrow"});
    arrow_writer.write(1, 2, 3);
    arrow_writer.close();
}
