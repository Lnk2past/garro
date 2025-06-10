#pragma once

#include <string>

namespace garro
{
    template <typename T>
    struct Column
    {
        using type = T;
        std::string name;
    };
}
