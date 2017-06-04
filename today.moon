day = tonumber os.date "%d" -- strip leading zero
tex.sprint os.date "\\date{\\hyperref[%Y/%m/%d]{%B #{day}, %Y}}"
