#include "garro/garro.hpp"

#include <print>
#include <string>

auto main() -> int
{
    {
        using garro::feather::Column;
        auto writer = garro::feather::Writer{garro::buffer_policies::MaxRows{2}, Column<int>("a"), Column<double>("b"),
                                             Column<std::string>("c")};
        writer.open("test1.arrow");
        writer.write(1, 3.14, "hello world");
        writer.write(1, 3.14, "hello world");

        std::println("setting...");

        writer.set_buffer_policy([i = 0](const auto &) mutable {
            if (((i++) % 2) == 0)
            {
                std::println("!!!");
                return true;
            }
            else
            {
                std::println("???");
                return false;
            }
        });

        writer.write(1, 3.14, "hello world");
        writer.write(1, 3.14, "hello world");
    }
}