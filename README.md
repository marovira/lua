# The Lua Programming Language with Modern CMake


[![Build](https://github.com/marovira/lua/actions/workflows/build.yml/badge.svg)](https://github.com/marovira/lua/actions/workflows/build.yml)

## Introduction

This repository contains the CMake files for the Lua Programming Language aimed at those
that wish to use the library in [Modern CMake](https://cliutils.gitlab.io/modern-cmake/README.html).

> [!NOTE]
> The bundle provided here is aimed at *modern* CMake. CMake has come a long way as a
> build generation tool and most modern systems now ship with CMake versions 3.20+ by
> default. As a result, this bundle **requires** a minimum CMake version of 3.30+.


![logo](https://github.com/marovira/lua/blob/master/logo.png)

## Usage Instructions

There are a couple of ways to integrate this bundle into your project. All of
them will use the same linking code, so let's discuss how to include it first.

### As a Subdirectory

The easiest way is to clone this repository directly into your source tree (i.e.
under `./external/lua` for example) and then add this to your
`CMakeLists.txt` file

```cmake
add_subdirectory(<path-to-lua-dir>)
```

You can also add this repository as a submodule using git.

### Using `FetchContent`

An alternative is to have CMake deal with downloading the code via `FetchContent`. To
add this, add the following to your `CMakeLists.txt`:

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

The final option is to directly install the bundle. Build the project and run the
install target with your chosen prefix:

```bash
cmake --install build --prefix <install-dir>
```

Then add the following to your `CMakeLists.txt`, passing
`-DCMAKE_PREFIX_PATH=<install-dir>` when configuring your project:

```cmake
find_package(lua CONFIG REQUIRED)
```

### Linking

Once you have added Lua to your build, you can link against it by adding:

```cmake
target_link_libraries(<your-target> PRIVATE lua::lua)
```

Once that is done you can include the Lua headers as follows:

```c++
#include <lua.hpp>
```

You will find an example executable under the `./test` directory containing a
sample CMake configuration for building with this bundle.

## Licences

Lua is published under the MIT licence and can be viewed
[here](https://github.com/marovira/lua/blob/master/LUA_LICENSE). For more
information, please see their official website [here](https://www.lua.org/).

This bundle is published under the BSD-3 licence and can be viewed [here](https://github.com/marovira/lua/blob/master/LICENSE)
