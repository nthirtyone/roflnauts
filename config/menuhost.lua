local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

local map_selector = selector:new(menu)

return {
	map_selector
		:setPosition(width/2, 40)
		:setSize(80, 42)
		:setMargin(0)
		:set("global", true)
		:set("first", true)
		:set("list", require "maplist")
		:set("icons_i", love.graphics.newImage("assets/placeholder-map-icon.png"))
		:set("icons_q", require "mapicons")
		:set("shape", "panorama")
		:init()
	,
	button:new(menu)
		:setText("Select")
		:setPosition(bx,101)
		:set("isEnabled", function ()
				return map_selector:isLocked()
			end)
		:set("active", function (self)
				MAP = map_selector:getFullSelection(true)[1][1]
				self.parent:load("menuselect")
			end)
	,
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,117)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
}