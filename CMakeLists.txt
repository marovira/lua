#================================
# Project setup.
#================================
cmake_minimum_required(VERSION 3.11)
project(lua VERSION 5.4.3 LANGUAGES CXX C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if (POLICY CMP0072)
    cmake_policy(SET CMP0072 NEW)
endif()

#================================
# Option variables.
#================================
option(LUA_BUILD_COMPILER "Build Lua compiler" ON)
option(LUA_BUILD_INTERPRETER "Build Lua interpreter" ON)
option(LUA_BUILD_TEST "Build test app" OFF)
option(LUA_INSTALL_TARGET "Create install target" OFF)

#================================
# Directory variables.
#================================
set(LUA_SOURCE_DIR ${PROJECT_SOURCE_DIR})
set(LUA_SOURCE_ROOT ${LUA_SOURCE_DIR}/src)
set(LUA_TEST_ROOT ${LUA_SOURCE_ROOT}/test)

#================================
# Add subdirectories.
#================================
add_subdirectory(${LUA_SOURCE_ROOT})

#================================
# Lua library.
#================================
source_group("include" FILES ${LUA_LIBRARY_INCLUDE})
source_group("source" FILES ${LUA_LIBRARY_SOURCE})
add_library(lua_lib ${LUA_LIBRARY_INCLUDE} ${LUA_LIBRARY_SOURCE})
target_include_directories(lua_lib PUBLIC
    $<BUILD_INTERFACE:${LUA_SOURCE_ROOT}>
    $<INSTALL_INTERFACE:include>
    )
target_compile_features(lua_lib PRIVATE cxx_std_17)
set_target_properties(lua_lib PROPERTIES DEBUG_POSTFIX "d")
add_library(lua::lua ALIAS lua_lib)
set_target_properties(lua_lib PROPERTIES FOLDER "lua")

#================================
# Lua compiler.
#================================
if (LUA_BUILD_COMPILER)
    source_group("source" FILES ${LUA_COMPILER_SOURCE})
    add_executable(luac ${LUA_COMPILER_SOURCE})
    target_link_libraries(luac PRIVATE lua_lib)
    set_target_properties(luac PROPERTIES FOLDER "lua")
endif()

#================================
# Lua interpreter
#================================
if (LUA_BUILD_INTERPRETER)
    source_group("source" FILES ${LUA_INTERPRETER_SOURCE})
    add_executable(lua ${LUA_INTERPRETER_SOURCE})
    target_link_libraries(lua PRIVATE lua_lib)
    set_target_properties(lua PROPERTIES FOLDER "lua")
endif()

#================================
# Lua interpreter
#================================
if (LUA_INSTALL_TARGET)
    install(TARGETS lua_lib
        EXPORT lua_lib
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION lib
        INCLUDES DESTINATION include
        )

    include(CMakePackageConfigHelpers)
    include(GNUInstallDirs)
    write_basic_package_version_file(
        "${PROJECT_BINARY_DIR}/luaConfigVersion.cmake"
        VERSION ${PACKAGE_VERSION}
        COMPATIBILITY AnyNewerVersion
        )

    install(EXPORT lua_lib
        FILE luaTargets.cmake
        NAMESPACE lua::
        DESTINATION lib/cmake/lua
        )

    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/lua-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/luaConfigVersion.cmake"
        DESTINATION lib/cmake/lua
        )

    install(FILES
        ${LUA_LIBRARY_PUBLIC_INCLUDE}
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/lua"
        )

    if (LUA_BUILD_COMPILER)
        install(TARGETS luac
            DESTINATION bin
            )
    endif()

    if (LUA_BUILD_INTERPRETER)
        install(TARGETS lua
            DESTINATION bin
            )
    endif()
endif()
