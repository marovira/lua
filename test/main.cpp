#include <lua.hpp>
#include <string>

int main()
{
    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    lua_close(L);
    return 0;
}