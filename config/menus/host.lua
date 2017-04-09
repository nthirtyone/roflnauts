local menu = ...

local button = require "not.Button"
local selector = require "not.Selector"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local map_selector = selector:new(menu)

require "iconsList"
local icons, maps = getMapsIconsList()

return {
	map_selector
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
	button:new(menu)
		:setText("Next")
		:setPosition(bx,101)
		:set("isEnabled", function ()
				return map_selector:isLocked()
			end)
		:set("active", function (self)
				MAP = map_selector:getFullSelection(true)[1][1] -- please, don't kill me for this, kek
				self.parent:open("select")
			end)
	,
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,117)
		:set("active", function (self)
				self.parent:open("main")
			end)
	,
}