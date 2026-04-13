#pragma once

#include <string_view>
#include <type_traits>

namespace garro::feather
{
template <typename T> struct Column
{
    using type = T;

    std::string_view name;
    arrow::CTypeTraits<type>::BuilderType builder{};

    Column(std::string_view n) : name(n)
    {
    }

    template <typename U> auto buffer(U &&t) -> void
    {
        [[maybe_unused]] auto status = builder.Append(t);
    }

    auto build() -> std::shared_ptr<arrow::Array>
    {
        auto array = std::shared_ptr<arrow::Array>{};
        [[maybe_unused]] auto status = builder.Finish(&array);
        return array;
    }

    auto clear() -> void
    {
        builder.Reset();
    }

    auto get_buffered_count() const -> std::uint32_t
    {
        return builder.length();
    }
};

template <typename> inline constexpr bool is_column = false;

template <typename T> inline constexpr bool is_column<Column<T>> = true;

template <typename T>
concept ColumnT = is_column<std::decay_t<T>>;
} // namespace garro::feather
