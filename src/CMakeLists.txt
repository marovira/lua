set(SRC_ROOT ${CMAKE_CURRENT_LIST_DIR})

set(LIB_SRC_LIST
    ${SRC_ROOT}/lapi.c
    ${SRC_ROOT}/lauxlib.c
    ${SRC_ROOT}/lbaselib.c
    ${SRC_ROOT}/lcode.c
    ${SRC_ROOT}/lcorolib.c
    ${SRC_ROOT}/lctype.c
    ${SRC_ROOT}/ldblib.c
    ${SRC_ROOT}/ldebug.c
    ${SRC_ROOT}/ldo.c
    ${SRC_ROOT}/ldump.c
    ${SRC_ROOT}/lfunc.c
    ${SRC_ROOT}/lgc.c
    ${SRC_ROOT}/linit.c
    ${SRC_ROOT}/liolib.c
    ${SRC_ROOT}/llex.c
    ${SRC_ROOT}/lmathlib.c
    ${SRC_ROOT}/lmem.c
    ${SRC_ROOT}/loadlib.c
    ${SRC_ROOT}/lobject.c
    ${SRC_ROOT}/lopcodes.c
    ${SRC_ROOT}/loslib.c
    ${SRC_ROOT}/lparser.c
    ${SRC_ROOT}/lstate.c
    ${SRC_ROOT}/lstring.c
    ${SRC_ROOT}/lstrlib.c
    ${SRC_ROOT}/ltable.c
    ${SRC_ROOT}/ltablib.c
    ${SRC_ROOT}/ltm.c
    ${SRC_ROOT}/lundump.c
    ${SRC_ROOT}/lutf8lib.c
    ${SRC_ROOT}/lvm.c
    ${SRC_ROOT}/lzio.c
)

set(LIB_INCLUDE_LIST
    ${SRC_ROOT}/lapi.h
    ${SRC_ROOT}/lauxlib.h
    ${SRC_ROOT}/lcode.h
    ${SRC_ROOT}/lctype.h
    ${SRC_ROOT}/ldebug.h
    ${SRC_ROOT}/ldo.h
    ${SRC_ROOT}/lfunc.h
    ${SRC_ROOT}/lgc.h
    ${SRC_ROOT}/ljumptab.h
    ${SRC_ROOT}/llex.h
    ${SRC_ROOT}/llimits.h
    ${SRC_ROOT}/lmem.h
    ${SRC_ROOT}/lobject.h
    ${SRC_ROOT}/lopcodes.h
    ${SRC_ROOT}/lopnames.h
    ${SRC_ROOT}/lparser.h
    ${SRC_ROOT}/lprefix.h
    ${SRC_ROOT}/lstate.h
    ${SRC_ROOT}/lstring.h
    ${SRC_ROOT}/ltable.h
    ${SRC_ROOT}/ltm.h
    ${SRC_ROOT}/lua.h
    ${SRC_ROOT}/luaconf.h
    ${SRC_ROOT}/lualib.h
    ${SRC_ROOT}/lundump.h
    ${SRC_ROOT}/lvm.h
    ${SRC_ROOT}/lzio.h
)

#================================
# Libraries.
#================================
set(LIBS)
if (UNIX AND NOT APPLE)
    include(CheckLibraryExists)
    check_library_exists(m sin "" HAVE_LIB_M)
    if (HAVE_LIB_M)
        list(APPEND LIBS m)
    endif()

endif()

#================================
# Lua library.
#================================
source_group("include" FILES ${LIB_INCLUDE_LIST})
source_group("source" FILES ${LIB_SRC_LIST})
add_library(liblua ${LIB_INCLUDE_LIST} ${LIB_SRC_LIST})
target_include_directories(liblua PUBLIC
    $<BUILD_INTERFACE:${SRC_ROOT}>
    $<INSTALL_INTERFACE:include>
    )
if (UNIX AND NOT APPLE)
    target_link_libraries(liblua PUBLIC ${LIBS})
endif()
target_compile_features(liblua PRIVATE cxx_std_20)
set_target_properties(liblua PROPERTIES DEBUG_POSTFIX "d")
add_library(lua::lua ALIAS liblua)
set_target_properties(liblua PROPERTIES FOLDER "lua")

#================================
# Lua compiler.
#================================
if (LUA_BUILD_COMPILER)
    set(COMPILER_SRC ${SRC_ROOT}/luac.c)
    source_group("source" FILES ${COMPILER_SRC})
    add_executable(luac ${COMPILER_SRC})
    target_link_libraries(luac PRIVATE liblua)
    set_target_properties(luac PROPERTIES FOLDER "lua")
endif()

#================================
# Lua interpreter
#================================
if (LUA_BUILD_INTERPRETER)
    set(INTERP_SRC ${SRC_ROOT}/lua.c)
    source_group("source" FILES ${INTERP_SRC})
    add_executable(lua ${INTERP_SRC})
    target_link_libraries(lua PRIVATE liblua)
    set_target_properties(lua PROPERTIES FOLDER "lua")
endif()


set(LUA_INSTALL_INCLUDE
    ${LUA_SOURCE_ROOT}/lauxlib.h
    ${LUA_SOURCE_ROOT}/lua.h
    ${LUA_SOURCE_ROOT}/lua.hpp
    ${LUA_SOURCE_ROOT}/luaconf.h
    ${LUA_SOURCE_ROOT}/lualib.h
    PARENT_SCOPE)
