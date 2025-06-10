message(STATUS "Conan: Using CMakeDeps conandeps_legacy.cmake aggregator via include()")
message(STATUS "Conan: It is recommended to use explicit find_package() per dependency instead")

find_package(fmt)
find_package(nlohmann_json)
find_package(Arrow)
find_package(SQLite3)

set(CONANDEPS_LEGACY  fmt::fmt  nlohmann_json::nlohmann_json  arrow::arrow  SQLite::SQLite3 )