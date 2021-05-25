cmake_minimum_required(VERSION 3.11)
project(lua_test LANGUAGES CXX C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if (POLICY CMP0072)
    cmake_policy(SET CMP0072 NEW)
endif()

set(ROOT_DIR ${PROJECT_SOURCE_DIR})
set(CMAKE_DIR "${ROOT_DIR}/../cmake")

set(LUA_BUILD_COMPILER OFF CACHE INTERNAL "")
set(LUA_BUILD_INTERPRETER OFF CACHE INTERNAL "")

include(FetchContent)

FetchContent_Declare(
    lua
    GIT_REPOSITORY https://github.com/marovira/lua
    )

find_package(lua QUIET)

if (NOT LUA_FOUND AND NOT lua_POPULATED)
    FetchContent_MakeAvailable(lua)
endif()

source_group("source" FILES ${ROOT_DIR}/main.cpp)
add_executable(lua_test ${ROOT_DIR}/main.cpp)
target_link_libraries(lua_test PRIVATE lua::lua)
target_compile_features(lua_test PRIVATE cxx_std_17)