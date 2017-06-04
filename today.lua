local day = tonumber(os.date("%d"))
return tex.sprint(os.date("\\date{\\hyperref[%Y/%m/%d]{%B " .. tostring(day) .. ", %Y}}"))
