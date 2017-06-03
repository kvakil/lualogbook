module "dincluder", package.seeall
local *

is_dotfile = (filename) -> filename\match("^%.") != nil

explode_name = (filename) -> filename\match "([^.]+)%.([^.]+)"

nice_month = (filename) ->
    year, month = filename\match "([^/]+)/([^/]+)"
    utime = os.time(:year, :month, day: 1)
    os.date "%B %Y", utime

print_month = (month) -> tex.sprint "\\chapter{#{nice_month month}}\\clearpage"

ordinal_suffix = (number) ->
    switch number % 10
        when 1 then "st"
        when 2 then "nd"
        when 3 then "rd"
        else "th"

nice_date = (filename) ->
    year, month, day = filename\match "([^/]+)/([^/]+)/([^/]+)"
    utime = os.time(:year, :month, :day)
    day_of_week = os.date "%A", utime
    month_name = os.date "%B", utime
    nice_day = "#{tonumber day}#{ordinal_suffix day}"
    "#{day_of_week}, #{month_name} #{nice_day}"

include = (directory) ->
    yield_tree = (cd) ->
        for entry in lfs.dir cd
            if not is_dotfile entry
                entry = cd .. "/" .. entry
                coroutine.yield entry
                if lfs.isdir entry
                    yield_tree entry

    coroutine.wrap -> yield_tree directory

include_tree = (directory) ->
    for filename in include directory
        if lfs.isdir filename
            print_month filename
        else
            basename, ext = explode_name filename
            if ext == "tex"
                include_day basename

export include_day = (day) ->
    tex.sprint "\\section{#{nice_date day}}"
    tex.sprint "\\label{#{day}}"
    tex.sprint "\\include*{#{day}}"
    tex.sprint "\\clearpage"

export include_year = (year) -> include_tree year
export include_month = (month) ->
    print_month month
    include_tree month
