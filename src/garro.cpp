#include "garro/garro.hpp"

#include <chrono>
#include <iostream>
#include <string>
#include <thread>

using namespace std::chrono_literals;

auto main() -> int
{
    auto writer = garro::feather::Writer{garro::buffer_policies::MaxRows{3}, garro::feather::Column<int>("a"),
                                         garro::feather::Column<double>("b"), garro::feather::Column<std::string>("c")};

    writer.open("test.arrow");
    writer.write(1, 3.14, "hello world");
    writer.write(1, 3.14, "hello world");
    writer.write(1, 3.14, "hello world");
    writer.write(1, 3.14, "hello world");
    writer.write(1, 3.14, "hello world");
    writer.write(1, 3.14, "hello world");
}