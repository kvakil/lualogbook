--- Adds a hyperlink to the section with the current date in \date
-- @module today
-- @author Keyhan Vakil
-- @license MIT
module "today", package.seeall
local *

day = tonumber os.date "%d" -- strip leading zero
tex.sprint os.date "\\date{\\hyperref[%Y/%m/%d]{%B #{day}, %Y}}"

{}
