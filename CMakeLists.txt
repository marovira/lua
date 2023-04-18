#================================
# Project setup.
#================================
cmake_minimum_required(VERSION 3.24)
project(lua VERSION 5.4.4 LANGUAGES CXX C)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

#================================
# Option variables.
#================================
option(LUA_BUILD_COMPILER "Build Lua compiler" OFF)
option(LUA_BUILD_INTERPRETER "Build Lua interpreter" OFF)
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
# Packages.
#================================
set(LUA_LIBS)
if (UNIX AND NOT APPLE)
    include(CheckLibraryExists)
    check_library_exists(m sin "" HAVE_LIB_M)
    if (HAVE_LIB_M)
        list(APPEND LUA_LIBS m)
    endif()

endif()

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
if (UNIX AND NOT APPLE)
    target_link_libraries(lua_lib PUBLIC ${LUA_LIBS})
endif()
target_compile_features(lua_lib PRIVATE cxx_std_20)
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
        COMPATIBILITY ExactVersion
        )

    install(EXPORT lua_lib
        FILE luaTargets.cmake
        NAMESPACE lua::
        DESTINATION lib/cmake/lua
        )

    install(FILES
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/luaConfig.cmake"
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Findlua.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/luaConfigVersion.cmake"
        DESTINATION lib/cmake/lua
        )

    install(FILES
        ${LUA_LIBRARY_PUBLIC_INCLUDE}
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/lua"
        )

    if (MSVC)
        set(PDB_DIR_SUFFIX 
            "$<$<CONFIG:Debug>:Debug>$<$<CONFIG:RelWithDebInfo>:RelWithDebInfo>")
        set(LIB_SUFFIX "$<$<CONFIG:Debug>:d>")

        set(PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PDB_DIR_SUFFIX}")
        set(PDB_NAME "lua_lib${LIB_SUFFIX}.pdb")
        install(FILES
            "${PDB_OUTPUT_DIRECTORY}/${PDB_NAME}"
            DESTINATION lib OPTIONAL)
    endif()

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
