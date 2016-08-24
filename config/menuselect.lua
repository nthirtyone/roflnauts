local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()

return {
	button:new(menu)
		:setText("Go back")
		:setPosition(10,height-25)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
	selector:new(menu)
		:setPosition(10,10)
		:set("list", require "nautslist")
		:set("global", false)
		:init()
	,
}