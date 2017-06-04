--- Adds the ability to load luarocks packages from LuaTeX
-- @module luarockspackages
-- @author Keyhan Vakil
-- @license MIT
module "luarockspackages", package.seeall
local *

is_lua_module = (filename) -> filename\sub(-4, -1) == ".lua"

create_new_searcher = (searcher_name, path) ->
    searcher = (package_name) ->
        filename, err = package.searchpath(package_name, path)
        if err
            string.format "\n\t[%s]: module not found: '%s' %s",
                            searcher_name, package_name, err
        else
            if is_lua_module filename
                loadfile filename
            else -- assume it's a C module
                symbol = filename\gsub("%.", "_")
                package.loadlib filename, "luaopen_" .. symbol

    searchers = package.loaders or package.searchers
    table.insert searchers, searcher

add_luarocks_searchers = ->
    handle = io.popen("luarocks path")
    if handle == nil
        error "could not get luarocks path (ensure shell escape is enabled)"

    for line in handle\lines()
        _, _, name, path = line\find "^export ([^=]*)='([^']*)'$"
        if path != nil
            create_new_searcher('luarocks ' .. name, path)

add_luarocks_searchers!
