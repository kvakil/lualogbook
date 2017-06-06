module("lua.luaextpackages", package.seeall)
local create_new_searcher
create_new_searcher = function(searcher_name, path, cmodule)
  local searcher
  searcher = function(package_name)
    local filename, err = package.searchpath(package_name, path)
    if err then
      return string.format("\n\t[%s]: module not found: '%s' %s", searcher_name, package_name, err)
    else
      if cmodule then
        local symbol = filename:gsub("%.", "_")
        return package.loadlib(filename, "luaopen_" .. symbol)
      else
        return loadfile(filename)
      end
    end
  end
  local searchers = package.loaders or package.searchers
  return table.insert(searchers, searcher)
end
create_new_searcher('package.path', package.path, false)
create_new_searcher('package.cpath', package.cpath, true)
return { }
