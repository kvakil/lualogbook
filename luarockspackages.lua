module("luarockspackages", package.seeall)
local is_lua_module, create_new_searcher, add_luarocks_searchers
is_lua_module = function(filename)
  return filename:sub(-4, -1) == ".lua"
end
create_new_searcher = function(searcher_name, path)
  local searcher
  searcher = function(package_name)
    local filename, err = package.searchpath(package_name, path)
    if err then
      return string.format("\n\t[%s]: module not found: '%s' %s", searcher_name, package_name, err)
    else
      if is_lua_module(filename) then
        return loadfile(filename)
      else
        local symbol = filename:gsub("%.", "_")
        return package.loadlib(filename, "luaopen_" .. symbol)
      end
    end
  end
  local searchers = package.loaders or package.searchers
  return table.insert(searchers, searcher)
end
add_luarocks_searchers = function()
  local handle = io.popen("luarocks path")
  if handle == nil then
    error("could not get luarocks path (ensure shell escape is enabled)")
  end
  for line in handle:lines() do
    local _, name, path
    _, _, name, path = line:find("^export ([^=]*)='([^']*)'$")
    if path ~= nil then
      create_new_searcher('luarocks ' .. name, path)
    end
  end
end
return add_luarocks_searchers()
