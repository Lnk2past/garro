#include "garro/garro.hpp" // Includes garro::csv::Writer, garro::feather::Writer, garro::sqlite::Writer, garro::duckdb::Writer

#include <chrono>
#include <fstream>
#include <print>
#include <ranges>
#include <vector>
#include <string>
#include <tuple>
#include <memory>   // For std::unique_ptr
#include <utility>  // For std::forward
#include <iostream> // For std::cerr in case of exceptions

// --- 1. Helper to generate a single row of data based on Column definitions ---
template <typename... ColumnDefs, size_t... Is>
auto generate_data_row_impl(int row_index, std::index_sequence<Is...>)
{
    return std::make_tuple(
        // Lambda for each column to generate its specific value
        ([](int idx) { // No dummy arg needed here, type will be deduced from ColumnDefs
            // Get the actual data type of the column at compile time
            using ColDef = std::tuple_element_t<Is, std::tuple<ColumnDefs...>>;
            using ColType = typename ColDef::type;

            if constexpr (std::is_same_v<ColType, int>)
            {
                return idx + Is; // Simple integer value
            }
            else if constexpr (std::is_same_v<ColType, double>)
            {
                return static_cast<double>(idx + Is) * 0.1; // Simple double value
            }
            else if constexpr (std::is_same_v<ColType, std::string>)
            {
                return "data_string_" + std::to_string(idx + Is); // Simple string value
            }
            else
            {
                static_assert(!sizeof(ColDef), "Unsupported column type for data generation in benchmark");
            }
        })(row_index)... // Call the lambda for each element
    );
}

template <typename... ColumnDefs>
auto generate_data_row(int row_index)
{
    return generate_data_row_impl<ColumnDefs...>(row_index, std::make_index_sequence<sizeof...(ColumnDefs)>{});
}

// --- 2. Core measurement loop ---
template <typename WriterInstance, typename... ColumnDefs>
void run_measurement_loop(WriterInstance &writer, int row_count, int flush_interval)
{
    auto start = std::chrono::high_resolution_clock::now();

    for (int i = 0; i < row_count; ++i)
    {
        // Generate the tuple of values for the current row
        auto row_data_tuple = generate_data_row<ColumnDefs...>(i);

        // Unpack the tuple and buffer the values
        std::apply([&](auto &&...args)
                   { writer.buffer(std::forward<decltype(args)>(args)...); }, row_data_tuple);

        // Flush based on the interval
        if (flush_interval > 0 && (i + 1) % flush_interval == 0)
        {
            writer.flush();
        }
    }
    writer.flush(); // Always flush any remaining data at the end

    auto duration = std::chrono::high_resolution_clock::now() - start;
    auto seconds = std::chrono::duration_cast<std::chrono::duration<double>>(duration).count();
    std::println("    N={:<10} FlushInterval={:<10} Time={:0<1.6f}s", row_count, flush_interval, seconds);
}

// --- 3. Benchmark orchestrator for a specific writer and column set ---
// This function directly takes the ColumnDefs as a template parameter pack
template <template <typename...> typename WriterTemplate, typename... ColumnDefs>
void run_benchmark_for_writer_and_columns(const std::string &writer_name,
                                          const std::string &column_set_name,
                                          const std::vector<int> &row_counts,
                                          const std::vector<int> &flush_intervals,
                                          ColumnDefs &&...column_definitions)
{ // <-- Column instances are passed here
    std::println("\n--- Benchmarking {} with Columns: {} ---", writer_name, column_set_name);

    // Lambda to create the Writer instance. It captures the forwarded column_definitions.
    auto create_writer_lambda = [&](auto &&...cols_args)
    {
        // std::decay_t is crucial here to remove ref/const qualifiers and get the base type for the Writer template
        return new WriterTemplate<std::decay_t<decltype(cols_args)>...>(std::forward<decltype(cols_args)>(cols_args)...);
    };

    for (int N : row_counts)
    {
        for (int flush_interval : flush_intervals)
        {
            try
            {
                // Use the lambda to create the writer, forwarding the column definitions
                std::unique_ptr<WriterTemplate<std::decay_t<ColumnDefs>...>> writer(
                    create_writer_lambda(std::forward<ColumnDefs>(column_definitions)...));

                // Construct the file path
                auto path = std::filesystem::path{"benchmark_test"};
                path += writer->ext; // Use -> because it's a unique_ptr

                // Ensure the file is fresh for each test run if it exists
                if (std::filesystem::exists(path))
                {
                    std::filesystem::remove(path);
                }

                writer->open(path); // Open the writer

                // Run the measurement loop
                run_measurement_loop<decltype(*writer), std::decay_t<ColumnDefs>...>(*writer, N, flush_interval);

                writer->close(); // Explicitly close the writer
            }
            catch (const std::exception &e)
            {
                std::cerr << "    Error during benchmark (N=" << N << ", Flush=" << flush_interval << "): " << e.what() << std::endl;
            }
            catch (...)
            {
                std::cerr << "    Unknown error during benchmark (N=" << N << ", Flush=" << flush_interval << ")" << std::endl;
            }
        }
    }
}

// --- 4. Helper functions to get column instances as a tuple ---
// These functions return a std::tuple of garro::Column objects.
// This allows `std::apply` to unpack them into the `run_benchmark_for_writer_and_columns` function.
namespace ColumnSets
{
    auto get_int_double_string_columns()
    {
        return std::make_tuple(
            garro::Column<int>("id"),
            garro::Column<double>("value"),
            garro::Column<std::string>("name"));
    }

    auto get_many_ints_columns()
    {
        return std::make_tuple(
            garro::Column<int>("i1"),
            garro::Column<int>("i2"),
            garro::Column<int>("i3"),
            garro::Column<int>("i4"),
            garro::Column<int>("i5"),
            garro::Column<int>("i6"),
            garro::Column<int>("i7"),
            garro::Column<int>("i8"),
            garro::Column<int>("i9"),
            garro::Column<int>("i10"));
    }

    auto get_mixed_types_columns()
    {
        return std::make_tuple(
            garro::Column<int>("idx"),
            garro::Column<std::string>("category"),
            garro::Column<double>("measurement"),
            garro::Column<int>("count"),
            garro::Column<std::string>("description"));
    }
} // namespace ColumnSets

// --- Helper to bridge std::tuple to variadic template function ---
template <template <typename...> typename WriterTemplate, typename TupleOfColumns>
void run_bench_case_dispatcher(const std::string &writer_name, const std::string &column_set_name,
                               const std::vector<int> &row_counts, const std::vector<int> &flush_intervals,
                               TupleOfColumns &&column_tuple)
{
    // Use std::apply to unpack the tuple of Column objects into the run_benchmark_for_writer_and_columns function
    std::apply([&](auto &&...cols)
               { run_benchmark_for_writer_and_columns<WriterTemplate>(
                     writer_name, column_set_name, row_counts, flush_intervals,
                     std::forward<decltype(cols)>(cols)... // Forward the individual Column instances
                 ); }, std::forward<TupleOfColumns>(column_tuple));
}

// --- Main Benchmark Execution ---
auto main(int, char **) -> int
{
    // Define common test parameters
    std::vector<int> test_row_counts = {1, 10, 1000, 100000, 1000000}; // Up to 1 million rows
    std::vector<int> test_flush_intervals = {100, 0};                  // 0 for flush at end (larger interval than total rows)

    // --- CSV Writer Benchmarks ---
    std::println("########## CSV Writer Benchmarks ##########");
    run_bench_case_dispatcher<garro::csv::Writer>(
        "CSV Writer", "Int_Double_String (3 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_int_double_string_columns());
    run_bench_case_dispatcher<garro::csv::Writer>(
        "CSV Writer", "ManyInts (10 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_many_ints_columns());
    run_bench_case_dispatcher<garro::csv::Writer>(
        "CSV Writer", "MixedTypes (5 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_mixed_types_columns());

    // --- Feather Writer Benchmarks ---
    std::println("\n########## Feather Writer Benchmarks ##########");
    run_bench_case_dispatcher<garro::feather::Writer>(
        "Feather Writer", "Int_Double_String (3 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_int_double_string_columns());
    run_bench_case_dispatcher<garro::feather::Writer>(
        "Feather Writer", "ManyInts (10 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_many_ints_columns());
    run_bench_case_dispatcher<garro::feather::Writer>(
        "Feather Writer", "MixedTypes (5 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_mixed_types_columns());

    // --- SQLite Writer Benchmarks ---
    std::println("\n########## SQLite Writer Benchmarks ##########");
    run_bench_case_dispatcher<garro::sqlite::Writer>(
        "SQLite Writer", "Int_Double_String (3 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_int_double_string_columns());
    run_bench_case_dispatcher<garro::sqlite::Writer>(
        "SQLite Writer", "ManyInts (10 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_many_ints_columns());
    run_bench_case_dispatcher<garro::sqlite::Writer>(
        "SQLite Writer", "MixedTypes (5 cols)", test_row_counts, test_flush_intervals,
        ColumnSets::get_mixed_types_columns());
}