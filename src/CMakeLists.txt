add_executable(garro garro.cpp)

target_include_directories(garro PUBLIC "${CMAKE_SOURCE_DIR}/include" "${CMAKE_CURRENT_SOURCE_DIR}")

target_link_libraries(garro PUBLIC SQLite::SQLite3 arrow::arrow mcap::mcap nlohmann_json::nlohmann_json)
