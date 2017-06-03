module "dincluder", package.seeall

is_dotfile = (filename) -> filename\match("^%.") != nil

explode_name = (filename) -> filename\match "([^.]+)%.([^.]+)"

export include = (directory) ->
    yield_tree = (cd) ->
        for entry in lfs.dir cd
            if not is_dotfile entry
                entry = cd .. "/" .. entry
                coroutine.yield entry
                if lfs.isdir entry
                    yield_tree entry

    coroutine.wrap -> yield_tree directory

print_month = (month) -> tex.sprint "\\chapter{#{month}}\\clearpage"

nice_date = (filename) ->
    year, month, day = filename\match "([^/]+)/([^/]+)/([^/]+)"
    utime = os.time({
        year: year
        month: month
        day: day
    })
    os.date "%A, %Y-%m-%d"

export include_day = (day) ->
    tex.sprint "\\section{#{nice_date day}}"
    tex.sprint "\\label{#{day}}"
    tex.sprint "\\include*{#{day}}"
    tex.sprint "\\clearpage"

include_tree = (directory) ->
    for filename in include directory
        if lfs.isdir filename
            print_month filename
        else
            basename, ext = explode_name filename
            if ext == "tex"
                include_day basename

export include_year = (year) -> include_tree year
export include_month = (month) ->
    print_month month
    include_tree month


