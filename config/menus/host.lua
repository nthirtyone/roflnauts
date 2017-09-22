local menu, background = ...

local Button = require "not.Button"
local Selector = require "not.Selector"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

-- TODO: This is temporary solution for generating available maps list and portraits for them to pass to Selector.
local icons, maps = {}, {}
do
	local files = love.filesystem.getDirectoryItems("config/maps")
	for _,filename in pairs(files) do
		local path = string.format("config/maps/%s", filename)
		if love.filesystem.isFile(path) and filename ~= "readme.md" then
			local map = love.filesystem.load(path)()
			local i, name = map.portrait, map.name
			map.filename = path
			if i then
				table.insert(icons, love.graphics.newImage(map.portrait))
				table.insert(maps, map)
			end
		end
	end
end

local mapSelector = Selector(maps, nil, menu)

return {
	background,
	mapSelector
		:setPosition(width/2-40, 40)
		:set("shape", Selector.SHAPE_PANORAMA)
		:set("icons", icons)
		:set("getText", function (self)
				return self:getSelected().name
			end)
	,
	Button(menu)
		:setText("Next")
		:setPosition(bx,101)
		:set("isEnabled", function ()
				return mapSelector:getLocked()
			end)
		:set("active", function (self)
				MAP = mapSelector:getSelected()
				self.parent:open("select")
			end)
	,
	Button(menu)
		:setText("Go back")
		:setPosition(bx,117)
		:set("active", function (self)
				self.parent:open("main")
			end)
	,
}
