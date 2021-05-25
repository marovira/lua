# The Lua Programming Language

> The Lua Programming Language with Modern CMake

[![.github/workflows/clang.yml](https://github.com/marovira/lua/actions/workflows/clang.yml/badge.svg)](https://github.com/marovira/lua/actions/workflows/clang.yml)
[![.github/workflows/gcc.yml](https://github.com/marovira/lua/actions/workflows/gcc.yml/badge.svg)](https://github.com/marovira/lua/actions/workflows/gcc.yml)
[![.github/workflows/osx.yml](https://github.com/marovira/lua/actions/workflows/osx.yml/badge.svg)](https://github.com/marovira/lua/actions/workflows/osx.yml)
[![MSVC](https://github.com/marovira/lua/actions/workflows/msvc.yml/badge.svg)](https://github.com/marovira/lua/actions/workflows/msvc.yml)

## About

This is a bundle of the Lua Programming Language v5.4.3 that provides a modern
CMake script for easy inclusion into projects and installation. For usage
instructions, see the next section. 


![logo](https://github.com/marovira/lua/blob/master/logo.png)

## Usage Instructions

There are a couple of ways to integrate this bundle into your project. All of
them will use the same linking code, so let's discuss how to include it first.
You have 3 options. For the first two options, it is recommended that you add
the following to your CMakelists (especially if you only wish to link to the
library itself):

```cmake
set(LUA_BUILD_COMPILER OFF CACHE INTERNAL "")
set(LUA_BUILD_INTERPRETER OFF CACHE INTERNAL "")
```

Adding these two lines will disable the creation of the compiler and interpreter
targets for Lua. 

### As a Subdirectory

The easiest way is to clone this repository directly into your source tree (i.e.
under `./external/lua` for example) and then adding this to your
`CMakelists.txt` file

```cmake
add_subdirectory(<path-to-lua-dir>)
```

You can also add this repository as a submodule using git.

### Using `FetchContent`

An alternative use is to have CMake deal with downloading the code via
`FetchContent`. Note that this assumes you have version at least 3.11. To add
this, add the following to your `CMakelists.txt`:

```cmake
include(FetchContent)

FetchContent_Declare(
    lua
    GIT_REPOSITORY "https://github.com/marovira/lua"
    GIT_TAG "<latest-commit-hash>"
)

FetchContent_MakeAvailable(lua)
```

Where `<latest-commit-hash>` can be retrieved from this repository. 

### Installing

The final option is to directly install the bundle. To do this, you must install
it as with any other CMake package (build and run the install target). Once that
is done, you *must* copy `./cmake/Findlua.cmake` file into your project's
directory (ideally under `./cmake/Findlua.cmake`) and then add the following to
your `CMakelists.txt`:

```cmake
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} <your-cmake-dir>)
find_package(lua REQUIRED)
```

The reason why we need a separate `Findlua.cmake` file is very simple: CMake
does ship with a `FindLua.cmake`, but that file is written using an older CMake
style (so we can't link using `target_link_libraries`). Moreover, the way in
which you must install Lua isn't entirely straight-forward (especially if you
don't use a package manager) unless you read through the code and figure out
which directories it looks for. 

### Linking

Once you have added Lua to your build, you can link against it by adding:

```cmake
target_link_libraries(<your-target> PRIVATE lua::lua)
```

Once that is done you can include the Lua headers as follows:

```c++
#include <lua.h>
```

You will find an example executable under the `./test` directory containing a
sample CMake configuration for building with this bundle.

## Licenses

Lua is published under the MIT license and can be viewed
[here](https://github.com/marovira/lua/blob/master/LUA_LICENSE). For more
information, please see their official website [here](https://www.lua.org/).

This bundle is published under the BSD-3 license can can be viewed [here](https://github.com/marovira/lua/blob/master/LICENSE)
