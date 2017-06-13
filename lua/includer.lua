module("lua.includer", package.seeall)
local is_dotfile, explode_name, include, skeys, is_day_entry, ordinal_suffix, nice_date, output_day_entry, is_month, nice_month, output_month_entry
is_dotfile = function(filename)
  return filename:sub(1, 1) == '.'
end
explode_name = function(filename)
  return filename:match("([^.]+)%.([^.]+)")
end
include = function(directory)
  local helper
  helper = function(current_directory, files)
    for entry in lfs.dir(current_directory) do
      if not is_dotfile(entry) then
        entry = current_directory .. "/" .. entry
        files[entry] = true
        if lfs.isdir(entry) then
          helper(entry, files)
        end
      end
    end
  end
  local all_files = { }
  helper(directory, all_files)
  return all_files
end
skeys = function(t)
  local keys
  do
    local _accum_0 = { }
    local _len_0 = 1
    for k, _ in pairs(t) do
      _accum_0[_len_0] = k
      _len_0 = _len_0 + 1
    end
    keys = _accum_0
  end
  table.sort(keys)
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i]
    end
  end
end
is_day_entry = function(filename)
  return filename:match("^%d%d%d%d/%d%d/%d%d%.tex$") ~= nil
end
ordinal_suffix = function(number)
  local _exp_0 = number
  if 1 == _exp_0 then
    return "st"
  elseif 2 == _exp_0 then
    return "nd"
  elseif 3 == _exp_0 then
    return "rd"
  else
    return "th"
  end
end
nice_date = function(date)
  local year, month, day = date:match("([^/]+)/([^/]+)/([^/]+)")
  local utime = os.time({
    year = year,
    month = month,
    day = day
  })
  local day_of_week = os.date("%A", utime)
  local month_name = os.date("%B", utime)
  day = tonumber(day)
  local nice_day = tostring(day) .. tostring(ordinal_suffix(day))
  return tostring(day_of_week) .. ", " .. tostring(month_name) .. " " .. tostring(nice_day)
end
output_day_entry = function(filename)
  local basename, _ = explode_name(filename)
  tex.sprint("\\section{" .. tostring(nice_date(basename)) .. "}")
  tex.sprint("\\label{" .. tostring(basename) .. "}")
  tex.sprint("\\include*{" .. tostring(basename) .. "}")
  return tex.sprint("\\clearpage")
end
is_month = function(filename)
  return filename:match("^%d%d%d%d/%d%d$") ~= nil
end
nice_month = function(date)
  local year, month = date:match("([^/]+)/([^/]+)")
  local utime = os.time({
    year = year,
    month = month,
    day = 1
  })
  return os.date("%B %Y", utime)
end
output_month_entry = function(filename)
  tex.sprint("\\chapter{" .. tostring(nice_month(filename)) .. "}")
  return tex.sprint("\\clearpage")
end
lua.includer.include_recent = function(year, n)
  local all_files = include(year)
  local entry_files
  do
    local _accum_0 = { }
    local _len_0 = 1
    for f in skeys(all_files) do
      if is_day_entry(f) or is_month(f) then
        _accum_0[_len_0] = f
        _len_0 = _len_0 + 1
      end
    end
    entry_files = _accum_0
  end
  local skip = #entry_files - n
  for _, filename in ipairs(entry_files) do
    if skip < 1 then
      if is_day_entry(filename) then
        output_day_entry(filename)
      elseif is_month(filename) then
        output_month_entry(filename)
      end
    else
      skip = skip - 1
    end
  end
end
lua.includer.include_year = function(year)
  return lua.includer.include_recent(year, math.huge)
end
