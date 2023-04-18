#================================
# Project setup.
#================================
cmake_minimum_required(VERSION 3.24)
project(lua_test LANGUAGES CXX C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

#================================
# Directory variables.
#================================
set(ROOT_DIR ${PROJECT_SOURCE_DIR})
set(CMAKE_DIR ${ROOT_DIR}/../cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_DIR})

#================================
# Packages.
#================================
find_package(lua 5.4.4 QUIET)

if (NOT lua_FOUND)
    include(FetchContent)
    FetchContent_Declare(
        lua
        GIT_REPOSITORY https://github.com/marovira/lua
        )

    FetchContent_MakeAvailable(lua)
    list(APPEND CMAKE_MODULE_PATH ${lua_SOURCE_DIR}/cmake)
endif()

source_group("source" FILES ${ROOT_DIR}/main.cpp)
add_executable(lua_test ${ROOT_DIR}/main.cpp)
target_link_libraries(lua_test PRIVATE lua::lua)
