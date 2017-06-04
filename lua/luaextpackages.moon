--- Adds the ability to load external Lua packages from LuaTeX
-- @module luaextpackages
-- @author Keyhan Vakil
-- @license MIT
module "lua.luaextpackages", package.seeall
local *

--- creates a new searcher with the given name and pathspec
-- @tparam string searcher_name a name used for error messages
-- @tparam string path a pathspec ala package.searchpath
-- @tparam boolean cmodule whether the searcher is for C modules
-- @treturn string|function an error string, or the compiled module
create_new_searcher = (searcher_name, path, cmodule) ->
    searcher = (package_name) ->
        filename, err = package.searchpath(package_name, path)
        if err
            string.format "\n\t[%s]: module not found: '%s' %s",
                            searcher_name, package_name, err
        else
            if cmodule
                symbol = filename\gsub("%.", "_")
                package.loadlib filename, "luaopen_" .. symbol
            else -- lua module
                loadfile filename

    searchers = package.loaders or package.searchers
    table.insert searchers, searcher

create_new_searcher('package.path', package.path, false)
create_new_searcher('package.cpath', package.cpath, true)
{}
