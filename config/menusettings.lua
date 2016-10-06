local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

return {
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,117)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
}