## Top level cmake
cmake_minimum_required(VERSION 3.20)

project(
    PROJECT_NAME
    VERSION PROJECT_VERSION
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(cmake/CompilerOptions.cmake)
include(cmake/Dependencies.cmake)
include(cmake/grpc.cmake)

add_subdirectory(src)
add_subdirectory(tests)