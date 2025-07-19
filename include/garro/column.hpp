#pragma once

#include <string_view>

namespace garro
{
    template <typename T>
    struct Column
    {
        using type = T;
        std::string_view name;
    };
}
