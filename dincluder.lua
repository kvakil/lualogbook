module("dincluder", package.seeall)
local is_dotfile
is_dotfile = function(filename)
  return filename:match("^%.") ~= nil
end
local explode_name
explode_name = function(filename)
  return filename:match("([^.]+)%.([^.]+)")
end
include = function(directory)
  local yield_tree
  yield_tree = function(cd)
    for entry in lfs.dir(cd) do
      if not is_dotfile(entry) then
        entry = cd .. "/" .. entry
        coroutine.yield(entry)
        if lfs.isdir(entry) then
          yield_tree(entry)
        end
      end
    end
  end
  return coroutine.wrap(function()
    return yield_tree(directory)
  end)
end
include_all = function(directory)
  for filename in include(directory) do
    if lfs.isdir(filename) then
      tex.sprint("\\chapter{" .. tostring(filename) .. "}")
      tex.sprint("\\clearpage")
    else
      local basename, ext = explode_name(filename)
      if ext == "tex" then
        tex.sprint("\\section{" .. tostring(basename) .. "}")
        tex.sprint("\\label{" .. tostring(basename) .. "}")
        tex.sprint("\\include*{" .. tostring(basename) .. "}")
        tex.sprint("\\clearpage")
      end
    end
  end
end
