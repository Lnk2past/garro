#pragma once

#include <chrono>
#include <cstdint>

namespace garro::buffer_policies
{
struct Buffered
{
    auto operator()(const auto &writer) -> bool
    {
        return true;
    }
};

struct Unbuffered
{
    auto operator()(const auto &writer) -> bool
    {
        return true;
    }
};

struct MaxRows
{
    auto operator()(const auto &writer) -> bool
    {
        if ((c += writer.get_rows_buffered()) < n)
        {
            return true;
        }
        c = 0;
        return false;
    }

    std::uint32_t n{};
    std::uint32_t c{};
};

// struct MaxSize
// {
//     auto operator()(const auto &writer) -> bool
//     {
//         if ((c += writer.get_buffered_size()) < s)
//         {
//             return true;
//         }
//         c = 0;
//         return false;
//     }

//     std::uint32_t s{};
//     std::uint32_t c{};
// };

// struct time_since_last
// {
//     auto operator()(const auto &writer) -> bool
//     {
//     }
// };
} // namespace garro::buffer_policies