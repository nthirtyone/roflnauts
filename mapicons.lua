-- Maps icons list generation file
-- TODO: it is so similar to `nautsicons.lua` they could be merged together into one function that returns icon quad sequences (`createIconList(image, width, number, mask...) --[[ body ]] return image, icons, list end` or similar). On the other hand extended lists with maps/nauts in config would be enough.
local maps = require "maplist"
local w, h = 532, 37
local icons = {}

local i = 0
for _,map in pairs(maps) do
	icons[map] = love.graphics.newQuad(i*76, 0, 76, 37, w, h)
	i = i + 1
end
return icons
