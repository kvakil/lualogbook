module "dincluder", package.seeall

is_dotfile = (filename) -> filename\match("^%.") != nil

explode_name = (filename) -> filename\match("([^.]+)%.([^.]+)")

include_file = (basename) ->
    tex.sprint "\\include*{" .. basename .. "}"

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
    tex.sprint "\\chapter{" .. directory .. "}"
    tex.sprint "\\clearpage"
    for filename in include directory
        if lfs.isdir filename
            tex.sprint "\\section{" .. filename .. "}"
            tex.sprint "\\clearpage"
        else
            basename, ext = explode_name filename
            if ext == "tex"
                tex.sprint "\\subsection{" .. basename .. "}"
                tex.sprint "\\label{" .. basename .. "}"
                include_file basename
                tex.sprint "\\clearpage"
