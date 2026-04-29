cmake_minimum_required(VERSION 3.15)
project({{PACKAGE_NAME}} VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Library
add_library({{PACKAGE_NAME}}
    src/{{PACKAGE_NAME}}.cpp
)

target_include_directories({{PACKAGE_NAME}} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

# Tests
enable_testing()
add_executable({{PACKAGE_NAME}}_tests tests/test_main.cpp)
target_link_libraries({{PACKAGE_NAME}}_tests PRIVATE {{PACKAGE_NAME}})
add_test(NAME {{PACKAGE_NAME}}_tests COMMAND {{PACKAGE_NAME}}_tests)
