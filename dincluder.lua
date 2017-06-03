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
local print_month
print_month = function(month)
  return tex.sprint("\\chapter{" .. tostring(month) .. "}\\clearpage")
end
local nice_date
nice_date = function(filename)
  local year, month, day = filename:match("([^/]+)/([^/]+)/([^/]+)")
  local utime = os.time({
    year = year,
    month = month,
    day = day
  })
  return os.date("%A, %Y-%m-%d")
end
include_day = function(day)
  tex.sprint("\\section{" .. tostring(nice_date(day)) .. "}")
  tex.sprint("\\label{" .. tostring(day) .. "}")
  tex.sprint("\\include*{" .. tostring(day) .. "}")
  return tex.sprint("\\clearpage")
end
local include_tree
include_tree = function(directory)
  for filename in include(directory) do
    if lfs.isdir(filename) then
      print_month(filename)
    else
      local basename, ext = explode_name(filename)
      if ext == "tex" then
        include_day(basename)
      end
    end
  end
end
include_year = function(year)
  return include_tree(year)
end
include_month = function(month)
  print_month(month)
  return include_tree(month)
end
