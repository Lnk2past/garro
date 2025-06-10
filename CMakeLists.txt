cmake_minimum_required(VERSION 3.18.4)

project (garro)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(fmt CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(Arrow CONFIG REQUIRED)
find_package(SQLite3 CONFIG REQUIRED)

add_compile_options(-std=c++23)
add_compile_options(-Wall -Wextra -Wpedantic -Werror)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)

export(TARGETS garro FILE "${CMAKE_BINARY_DIR}/garroTargets.cmake")
