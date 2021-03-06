--- Includes all the .tex files in a given directory.
-- @module includer
-- @author Keyhan Vakil
-- @license MIT
module "lua.includer", package.seeall
local *

--- check if a file is a dotfile
-- @local here
-- @tparam string filename
-- @treturn boolean true iff the filename starts with . 
is_dotfile = (filename) -> filename\sub(1, 1) == '.'

--- split a file into its name and extension
-- @local here
-- @tparam string filename
-- @treturn string the basename of the file
-- @treturn string the extension of the file
explode_name = (filename) -> filename\match "([^.]+)%.([^.]+)"

--- creates a table of all the files and directories in directory
-- @local here
-- @tparam string directory to traverse
-- @treturn table all of the found files 
include = (directory) ->
    -- recursively adds files in current_directory to the files table
    helper = (current_directory, files) ->
        for entry in lfs.dir current_directory
            if not is_dotfile entry -- ignore hidden files, esp . and ..
                entry = current_directory .. "/" .. entry
                files[entry] = true
                if lfs.isdir entry
                    helper(entry, files)
    all_files = {}
    helper(directory, all_files)
    return all_files

--- iterator which traverses the keys of a table in sorted order
-- @local here
-- @tparam table t the table to traverse
-- @treturn function an iterator which traverses in the desired order
skeys = (t) ->
    keys = [ k for k, _ in pairs t ]
    table.sort(keys)
    i = 0
    return (using i) ->
        i = i + 1
        if keys[i]
            return keys[i]

--- checks if the given file is a daily log entry
-- @local here
-- @tparam string filename
-- @treturn boolean true iff filename matches YYYY/MM/DD.tex
is_day_entry = (filename) -> filename\match("^%d%d%d%d/%d%d/%d%d%.tex$") != nil

--- finds the ordinal suffix of the given number
-- @local here
-- @tparam number number
-- @treturn string the appropriate suffix (st, nd, rd or th)
ordinal_suffix = (number) ->
    switch number
        when 1 then "st"
        when 2 then "nd"
        when 3 then "rd"
        else "th"

--- formats a given date "nicely"
-- @local here
-- @tparam string date a YYYY/MM/DD string representing the date
-- @treturn string a nicely formatted date (day name, month name and day)
nice_date = (date) ->
    year, month, day = date\match "([^/]+)/([^/]+)/([^/]+)"
    utime = os.time(:year, :month, :day)
    day_of_week = os.date "%A", utime
    month_name = os.date "%B", utime
    day = tonumber day -- strip leading zero
    nice_day = "#{day}#{ordinal_suffix day}"
    "#{day_of_week}, #{month_name} #{nice_day}"

--- outputs the entry for the given day
-- @local here
-- @tparam string filename containing the entry
output_day_entry = (filename) ->
    basename, _ = explode_name filename
    tex.sprint "\\section{#{nice_date basename}}"
    tex.sprint "\\label{#{basename}}"
    tex.sprint "\\include*{#{basename}}"
    tex.sprint "\\clearpage"

--- checks if the given file is a monthly log directory
-- @local here
-- @tparam string filename
-- @treturn boolean true iff the filename matches YYYY/MM
is_month = (filename) -> filename\match("^%d%d%d%d/%d%d$") != nil

--- returns the month name and year
-- @local here
-- @tparam string date as a YYYY/MM string
-- @treturn string a nicely formatted month (month name and year)
nice_month = (date) ->
    year, month = date\match "([^/]+)/([^/]+)"
    utime = os.time(:year, :month, day: 1)
    os.date "%B %Y", utime

--- outputs the entry for the given month
-- @local here
-- @tparam string filename
output_month_entry = (filename) ->
    tex.sprint "\\chapter{#{nice_month filename}}"
    tex.sprint "\\clearpage"

--- includes recent entries
-- @tparam string year the year as a string (e.g. "2017")
-- @tparam int n the number of entries to include
lua.includer.include_recent = (year, n) ->
    all_files = include year
    entry_files = [f for f in skeys all_files when is_day_entry(f) or is_month(f)]
    -- @todo always include month including the days
    skip = #entry_files - n
    for _, filename in ipairs entry_files
        if skip < 1
            if is_day_entry filename
                output_day_entry filename
            elseif is_month filename
                output_month_entry filename
        else
            skip -= 1

--- includes all files in the directory year/
-- @tparam string year the year as a string (e.g. "2017")
lua.includer.include_year = (year) ->
    lua.includer.include_recent year, math.huge
