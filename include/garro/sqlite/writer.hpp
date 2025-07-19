#pragma once

#include <filesystem>
#include <sstream>
#include <string>
#include <string_view>
#include <tuple>
#include <vector>
#include <stdexcept> // For std::runtime_error

#include <sqlite3.h>

#include "garro/column.hpp"

namespace garro::sqlite
{
    // RAII Wrapper for sqlite3* (Database Connection)
    // This is the helper class you should ideally use for `db` member.
    // Defined here for completeness, assuming it's in the same header or an included one.
    class SQLiteConnectionHandle
    {
    public:
        sqlite3 *db_ptr = nullptr;

        SQLiteConnectionHandle() = default;
        explicit SQLiteConnectionHandle(const std::string &filename, int flags)
        {
            int rc = sqlite3_open_v2(filename.c_str(), &db_ptr, flags, NULL);
            if (rc != SQLITE_OK)
            {
                std::string error_msg = "Failed to open SQLite DB";
                if (db_ptr)
                {
                    error_msg += ": ";
                    error_msg += sqlite3_errmsg(db_ptr);
                    sqlite3_close(db_ptr);
                }
                else
                {
                    error_msg += ": (db pointer is null)";
                }
                throw std::runtime_error(error_msg);
            }
        }
        ~SQLiteConnectionHandle() { close(); }
        SQLiteConnectionHandle(const SQLiteConnectionHandle &) = delete;
        SQLiteConnectionHandle &operator=(const SQLiteConnectionHandle &) = delete;
        SQLiteConnectionHandle(SQLiteConnectionHandle &&other) noexcept : db_ptr(other.db_ptr) { other.db_ptr = nullptr; }
        SQLiteConnectionHandle &operator=(SQLiteConnectionHandle &&other) noexcept
        {
            if (this != &other)
            {
                close();
                db_ptr = other.db_ptr;
                other.db_ptr = nullptr;
            }
            return *this;
        }
        sqlite3 *get() const { return db_ptr; }
        operator sqlite3 *() const { return db_ptr; }  // Allow implicit conversion
        sqlite3 *operator->() const { return db_ptr; } // For convenience
        void close()
        {
            if (db_ptr)
            {
                sqlite3_close(db_ptr);
                db_ptr = nullptr;
            }
        }
    };

    // RAII Wrapper for sqlite3_stmt* (Prepared Statement)
    class SQLiteStatementHandle
    {
    public:
        sqlite3_stmt *stmt_ptr = nullptr;

        SQLiteStatementHandle() = default;
        explicit SQLiteStatementHandle(sqlite3_stmt *ptr) : stmt_ptr(ptr) {}
        ~SQLiteStatementHandle() { finalize(); }
        SQLiteStatementHandle(const SQLiteStatementHandle &) = delete;
        SQLiteStatementHandle &operator=(const SQLiteStatementHandle &) = delete;
        SQLiteStatementHandle(SQLiteStatementHandle &&other) noexcept : stmt_ptr(other.stmt_ptr) { other.stmt_ptr = nullptr; }
        SQLiteStatementHandle &operator=(SQLiteStatementHandle &&other) noexcept
        {
            if (this != &other)
            {
                finalize();
                stmt_ptr = other.stmt_ptr;
                other.stmt_ptr = nullptr;
            }
            return *this;
        }
        sqlite3_stmt *get() const { return stmt_ptr; }
        operator sqlite3_stmt *() const { return stmt_ptr; } // Allow implicit conversion
        void finalize()
        {
            if (stmt_ptr)
            {
                sqlite3_finalize(stmt_ptr);
                stmt_ptr = nullptr;
            }
        }
        void reset()
        {
            if (stmt_ptr)
            {
                sqlite3_reset(stmt_ptr);
                sqlite3_clear_bindings(stmt_ptr);
            }
        }
    };

    template <typename... Columns>
    class Writer
    {
        using ColumnTypes = std::tuple<Columns...>;
        using ValueTuple = std::tuple<typename Columns::type...>;

    public:
        static constexpr auto ext = std::string_view{".sqlite"};

        Writer(Columns &&...columns_) : columns(std::forward_as_tuple(columns_...))
        {
            set_schema((std::forward<Columns>(columns_))...);
            // cached_placeholders_str is no longer needed for the INSERT statement itself
            // as we will use a single prepared statement with '?' for each column.
        }

        ~Writer()
        {
            close();
        }

        auto open(const std::filesystem::path &path)
        {
            file_path = path;

            if (std::filesystem::exists(file_path))
            {
                std::filesystem::remove(file_path);
            }

            // Use the RAII connection handle
            db = SQLiteConnectionHandle(file_path.string(), SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE);

            std::stringstream ss_create_table;
            ss_create_table << "CREATE TABLE IF NOT EXISTS data (";
            for (size_t i = 0; i < col_names.size(); ++i)
            {
                ss_create_table << col_names[i] << " " << col_types[i];
                if (i < col_names.size() - 1)
                    ss_create_table << ", ";
            }
            ss_create_table << ");";

            char *errmsg = nullptr;
            if (sqlite3_exec(db.get(), ss_create_table.str().c_str(), nullptr, nullptr, &errmsg) != SQLITE_OK)
            {
                std::string error = errmsg;
                sqlite3_free(errmsg);
                throw std::runtime_error("Failed to create table: " + error);
            }

            // Set pragmas (these are fine as exec calls)
            sqlite3_exec(db.get(), "PRAGMA synchronous = OFF;", nullptr, nullptr, nullptr);
            sqlite3_exec(db.get(), "PRAGMA journal_mode = MEMORY;", nullptr, nullptr, nullptr);
            sqlite3_exec(db.get(), "PRAGMA temp_store = MEMORY;", nullptr, nullptr, nullptr);

            // --- IMPORTANT: Prepare the single-row INSERT statement ONCE ---
            std::stringstream ss_insert_prep;
            ss_insert_prep << "INSERT INTO data VALUES (";
            for (size_t i = 0; i < col_names.size(); ++i)
            {
                ss_insert_prep << "?"; // One placeholder per column
                if (i < col_names.size() - 1)
                    ss_insert_prep << ",";
            }
            ss_insert_prep << ");";

            sqlite3_stmt *raw_stmt = nullptr;
            if (sqlite3_prepare_v2(db.get(), ss_insert_prep.str().c_str(), -1, &raw_stmt, nullptr) != SQLITE_OK)
            {
                std::string error = sqlite3_errmsg(db.get());
                if (raw_stmt)
                    sqlite3_finalize(raw_stmt); // Finalize if partially prepared
                throw std::runtime_error("Failed to prepare insert statement: " + error);
            }
            insert_stmt = SQLiteStatementHandle(raw_stmt); // Store in RAII handle
        }

        void close()
        {
            flush();                // Flush any remaining buffered data
            insert_stmt.finalize(); // Finalize the prepared statement
            db.close();             // Close the database connection
        }

        template <typename... T>
        auto buffer(T &&...values) -> void
        {
            buffered_rows.emplace_back(std::make_tuple(std::forward<T>(values)...));
        }

        void flush()
        {
            if (buffered_rows.empty())
                return;

            // --- Begin a transaction for batching inserts ---
            if (sqlite3_exec(db.get(), "BEGIN TRANSACTION;", nullptr, nullptr, nullptr) != SQLITE_OK)
            {
                throw std::runtime_error("Failed to begin transaction: " + std::string(sqlite3_errmsg(db.get())));
            }

            for (const auto &row : buffered_rows)
            {
                insert_stmt.reset(); // Reset the statement for new bindings

                int bind_index = 1; // SQLite parameters are 1-indexed
                std::apply([&](auto &&...values)
                           {
                    // Fold expression to bind each value
                    ((
                        [&]() {
                            // Type dispatch for binding
                            using T_val = std::decay_t<decltype(values)>;
                            if constexpr (std::is_same_v<T_val, int>) {
                                sqlite3_bind_int(insert_stmt.get(), bind_index, values);
                            } else if constexpr (std::is_same_v<T_val, double>) {
                                sqlite3_bind_double(insert_stmt.get(), bind_index, values);
                            } else if constexpr (std::is_same_v<T_val, std::string>) {
                                sqlite3_bind_text(insert_stmt.get(), bind_index, values.c_str(), values.length(), SQLITE_TRANSIENT);
                            } else {
                                static_assert(!sizeof(T_val), "Unsupported type for SQLite binding");
                            }
                            bind_index++;
                        }()
                    ), ...); }, row);

                // Execute the statement
                if (sqlite3_step(insert_stmt.get()) != SQLITE_DONE)
                {
                    // If an error occurs, rollback the transaction and throw
                    std::string error_msg = "Failed to execute insert statement: " + std::string(sqlite3_errmsg(db.get()));
                    sqlite3_exec(db.get(), "ROLLBACK;", nullptr, nullptr, nullptr);
                    throw std::runtime_error(error_msg);
                }
            }

            // --- Commit the transaction ---
            if (sqlite3_exec(db.get(), "COMMIT;", nullptr, nullptr, nullptr) != SQLITE_OK)
            {
                throw std::runtime_error("Failed to commit transaction: " + std::string(sqlite3_errmsg(db.get())));
            }

            buffered_rows.clear();
        }

        template <typename... T>
        auto write(T &&...values) -> void
        {
            buffer(std::forward<T>(values)...);
            flush();
        }

    private:
        ColumnTypes columns;
        std::filesystem::path file_path;
        SQLiteConnectionHandle db;         // Use RAII handle for connection
        SQLiteStatementHandle insert_stmt; // Use RAII handle for prepared statement

        std::vector<std::string> col_names;
        std::vector<std::string> col_types;
        std::vector<std::tuple<typename Columns::type...>> buffered_rows;

        // cached_placeholders_str is no longer used for the main INSERT statement
        // but can be kept if needed for other dynamic SQL generation.
        // For this specific fix, it's not directly involved.
        std::string cached_placeholders_str;

        void set_schema(Columns &&...cols)
        {
            (col_names.emplace_back(std::string(cols.name)), ...);
            (col_types.emplace_back(to_sql_type<typename Columns::type>()), ...);
        }

        template <typename T>
        std::string to_sql_type()
        {
            if constexpr (std::is_same_v<T, int>)
                return "INTEGER";
            else if constexpr (std::is_same_v<T, double>)
                return "REAL";
            else if constexpr (std::is_same_v<T, std::string>)
                return "TEXT";
            else
                static_assert(!sizeof(T), "Unsupported type for SQLite");
        }

        // This function is still valid, but its result is no longer used in flush()
        // for the main insert statement.
        std::string placeholders() const
        {
            std::string result = "?";
            for (size_t i = 1; i < sizeof...(Columns); ++i)
                result += ",?";
            return result;
        }

        // Individual bind overloads are still used by the std::apply lambda in flush()
        void bind(sqlite3_stmt *stmt, int index, int value)
        {
            sqlite3_bind_int(stmt, index, value);
        }

        void bind(sqlite3_stmt *stmt, int index, double value)
        {
            sqlite3_bind_double(stmt, index, value);
        }

        void bind(sqlite3_stmt *stmt, int index, const std::string &value)
        {
            sqlite3_bind_text(stmt, index, value.c_str(), -1, SQLITE_TRANSIENT);
        }
    };
} // namespace garro::sqlite