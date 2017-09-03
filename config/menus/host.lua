local menu, background = ...

local Button = require "not.Button"
local Selector = require "not.Selector"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local map_Selector = Selector(menu)

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

-- TODO: This is temporary solution for generating available maps list and portraits for them to pass to Selector. See also: `iconsList`.
local icons, maps = {}, {}
do
	local files = love.filesystem.getDirectoryItems("config/maps")
	for _,filename in pairs(files) do
		local path = string.format("config/maps/%s", filename)
		if love.filesystem.isFile(path) and filename ~= "readme.md" then
			local map = love.filesystem.load(path)()
			local i, name = map.portrait, map.name
			if i then
				icons[name] = love.graphics.newQuad((i-1)*76, 0, 76, 37, 532, 37)
				table.insert(maps, name)
			end
		end
	end
end

return {
	background,
	map_Selector
		:setPosition(width/2, 40)
		:setSize(80, 42)
		:setMargin(0)
		:set("global", true)
		:set("first", true)
		:set("list", maps)
		:set("icons_i", love.graphics.newImage("assets/maps.png"))
		:set("icons_q", icons)
		:set("shape", "panorama")
		:init()
	,
	Button(menu)
		:setText("Next")
		:setPosition(bx,101)
		:set("isEnabled", function ()
				return map_Selector:isLocked()
			end)
		:set("active", function (self)
				MAP = map_Selector:getFullSelection(true)[1][1] -- please, don't kill me for this, kek
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
