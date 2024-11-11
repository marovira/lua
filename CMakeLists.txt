#================================
# Project setup.
#================================
cmake_minimum_required(VERSION 3.30)
project(lua VERSION 5.4.7 LANGUAGES CXX C)

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
# Lua interpreter
#================================
if (LUA_INSTALL_TARGET)
    install(TARGETS liblua
        EXPORT liblua
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

    install(EXPORT liblua
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
        set(PDB_NAME "liblua${LIB_SUFFIX}.pdb")
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
