module("lua.today", package.seeall)
local day
day = tonumber(os.date("%d"))
tex.sprint(os.date("\\date{\\hyperref[%Y/%m/%d]{%B " .. tostring(day) .. ", %Y}}"))
return { }
