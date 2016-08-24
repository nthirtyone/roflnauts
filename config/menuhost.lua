local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

local map_selector = selector:new(menu)

return {
	map_selector
		:setPosition(width/2, 10)
		:setSize(80, 42)
		:setMargin(0)
		:set("global", true)
		:set("list", require "maplist")
		:set("sprite", love.graphics.newImage("assets/placeholder-map-icon.png"))
		:set("quads", require "mapicons")
		:init()
	,
	button:new(menu)
		:setText("Select")
		:setPosition(bx,101)
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