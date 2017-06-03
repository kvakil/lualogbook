module "dincluder", package.seeall

is_dotfile = (filename) -> filename\match("^%.") != nil

explode_name = (filename) -> filename\match("([^.]+)%.([^.]+)")

export include = (directory) ->
    yield_tree = (cd) ->
        for entry in lfs.dir cd
            if not is_dotfile entry
                entry = cd .. "/" .. entry
                coroutine.yield entry
                if lfs.isdir entry
                    yield_tree entry

    coroutine.wrap -> yield_tree directory

export include_all = (directory) ->
    for filename in include directory
        if lfs.isdir filename
            tex.sprint "\\chapter{#{filename}}"
            tex.sprint "\\clearpage"
        else
            basename, ext = explode_name filename
            if ext == "tex"
                tex.sprint "\\section{#{basename}}"
                tex.sprint "\\label{#{basename}}"
                tex.sprint "\\include*{#{basename}}"
                tex.sprint "\\clearpage"
