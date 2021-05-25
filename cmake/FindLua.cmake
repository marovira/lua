# Locate Lua library
# This module defines
#  LUA_EXECUTABLE, if found
#  LUA_FOUND, if false, do not try to link to Lua 
#  LUA_LIBRARIES
#  LUA_INCLUDE_DIR, where to find lua.h
#  LUA_VERSION_STRING, the version of Lua found (since CMake 2.8.8)
#=============================================================================
# Copyright 2007-2009 Kitware, Inc.
# Modified to support modern CMake syntax by Mauricio A. Rovira Galvez 2021.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)
#
# The required version of Lua can be specified using the
# standard syntax, e.g. FIND_PACKAGE(Lua 5.1)
# Otherwise the module will search for any available Lua implementation

# Always search for the non-versioned Lua first.
set(_POSSIBLE_LUA_INCLUDE include include/lua)
set(_POSSIBLE_LUA_EXECUTABLE lua)
set(_POSSIBLE_LUA_LIBRARY_RELEASE lua lua_lib)
set(_POSSIBLE_LUA_LIBRARY_DEBUG luad lua_libd)

# Determine the possible naming suffixes (there is not standard for this).
if (lua_FIND_VERSION_MAJOR AND lua_FIND_VERSION_MINOR)
    set(_POSSBILE_SUFFIXES 
        "${lua_FIND_VERSION_MAJOR}${lua_FIND_VERSION_MINOR}"
        "${lua_FIND_VERSION_MAJOR}.${lua_FIND_VERSION_MINOR}"
        "-${lua_FIND_VERSION_MAJOR}.${lua_FIND_VERSION_MINOR}"
        )
else()
    set(_POSSIBLE_SUFFIXES
        "54" "5.4" "-5.4"
        "53" "5.3" "-5.3"
        "52" "5.2" "-5.2"
        )
endif()

if (WIN32)
    set(_POSSIBLE_PATHS
        "C:/Program Files/lua"
        "C:/Program Files (x86)/lua"
        )
else()
    set(_POSSIBLE_PATHS
        "~/Library/Frameworks"
        "/Library/Frameworks"
        "/usr/local"
        "/usr"
        "/sw"
        "/opt/local"
        "/opt/csw"
        "/opt"
        )
endif()

# Setup possible search names and locations.
foreach(_SUFFIX ${_POSSIBLE_SUFFIXES})
    list(APPEND _POSSIBLE_LUA_INCLUDE "include/lua$_SUFFIX")
    list(APPEND _POSSIBLE_LUA_EXECUTABLE "lua${_SUFFIX}")
    list(APPEND _POSSIBLE_LUA_LIBRARY_RELEASE "lua${_SUFFIX}")
    list(APPEND _POSSIBLE_LUA_LIBRARY_DEBUG "lua${_SUFFIX}d")
endforeach()

# Find the Lua executable.
find_program(LUA_EXECUTABLE
    NAMES ${_POSSIBLE_LUA_EXECUTABLE}
    HINTS $ENV{LUA_DIR}
    PATH_SUFFIXES bin
    PATHS ${_POSSIBLE_PATHS}
    )

# Find the Lua header.
find_path(LUA_INCLUDE_DIR lua.h
    HINTS $ENV{LUA_DIR} 
    PATH_SUFFIXES ${_POSSIBLE_LUA_INCLUDE}
    PATHS ${_POSSIBLE_PATHS}
    )

# Find the Lua library.
find_library(LUA_LIBRARY_RELEASE
    NAMES ${_POSSIBLE_LUA_LIBRARY_RELEASE}
    HINTS
    $ENV{LUA_DIR}
    PATH_SUFFIXES lib64 lib
    PATHS ${_POSSIBLE_PATHS}
    )

find_library(LUA_LIBRARY_DEBUG
    NAMES ${_POSSIBLE_LUA_LIBRARY_DEBUG}
    HINTS
    $ENV{LUA_DIR}
    PATH_SUFFIXES lib64 lib
    PATHS ${_POSSIBLE_PATHS}
    )

if (LUA_LIBRARY)
    if (UNIX AND NOT APPLE)
        find_library(LUA_MATH_LIBRARY m)
        set(LUA_LIBRARIES "${LUA_LIBRARY};${LUA_MATH_LIBRARY}" CACHE STRING "Lua
        libraries")
    else()
        set(LUA_LIBRARIES "${LUA_LIBRARY}" CACHE STRING "Lua libraries")
    endif()
endif()

if (LUA_INCLUDE_DIR AND EXISTS "${LUA_INCLUDE_DIR}/lua.h")
    file(STRINGS "${LUA_INCLUDE_DIR}/lua.h" lua_version_str REGEX "^#define[
    \t]+LUA_RELEASE[ \t]+\"Lua .+\"")
    string(REGEX REPLACE "^#define[ \t]+LUA_RELEASE[ \t]+\"Lua ([^\"]+)\".*"
        "\\1" LUA_VERSION_STRING "${lua_version_str}")
    unset(lua_version_str)
endif()

include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

find_package_handle_standard_args(lua
    REQUIRED_VARS LUA_LIBRARIES LUA_INCLUDE_DIR
    VERSION_VAR LUA_VERSION_STRING)
mark_as_advanced(LUA_INCLUDE_DIR LUA_LIBRARIES LUA_LIBRARY LUA_MATH_LIBRARY
    LUA_EXECUTABLE)

select_library_configurations(LUA)

if(LUA_FOUND AND NOT TARGET lua::lua_lib)
    add_library(lua::lua STATIC IMPORTED)
    set_target_properties(lua::lua PROPERTIES 
        IMPORTED_LOCATION_DEBUG ${LUA_LIBRARY_DEBUG}
        IMPORTED_LOCATION_RELEASE ${LUA_LIBRARY_RELEASE}
        IMPORTED_LOCATION_RELWITHDEBINFO ${LUA_LIBRARY_RELEASE}
        IMPORTED_LOCATION_MINSIZEREL ${LUA_LIBRARY_RELEASE}
        INTERFACE_INCLUDE_DIRECTORIES ${LUA_INCLUDE_DIR}
        )
endif()
