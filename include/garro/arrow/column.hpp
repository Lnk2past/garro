#pragma once

#include <string_view>
#include <type_traits>
#include <vector>

namespace garro::feather
{
template <typename T> struct Column
{
    using type = T;

    Column(std::string_view n) : name(n)
    {
    }

    std::string_view name;
    std::vector<type> data{};
    arrow::CTypeTraits<type>::BuilderType builder{};

    template <typename U> auto buffer(U &&t) -> void
    {
        data.push_back(t);
    }

    auto build() -> std::shared_ptr<arrow::Array>
    {
        auto array = std::shared_ptr<arrow::Array>{};
        std::ignore = builder.AppendValues(data);
        auto a = builder.Finish();
        return *a;
    }

    auto clear() -> void
    {
        data.clear();
        builder.Reset();
    }

    auto get_buffered_count() const -> std::uint32_t
    {
        return static_cast<std::uint32_t>(data.size());
    }
};

template <typename> inline constexpr bool is_column = false;

template <typename T> inline constexpr bool is_column<Column<T>> = true;

template <typename T>
concept ColumnT = is_column<std::decay_t<T>>;
} // namespace garro::feather
