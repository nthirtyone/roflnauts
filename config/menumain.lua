local menu = ...

local button = require "button"
local header = require "header"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local button_x = width/2-29

return {
	button:new(menu)
		:setText("Start")
		:setPosition(button_x, 80)
		:set("active", function (self)
				self.parent:load("menustart")
			end)
	,
	button:new(menu)
		:setText("Join")
		:setPosition(button_x, 96)
	,
	button:new(menu)
		:setText("Settings")
		:setPosition(button_x, 112)
	,
	button:new(menu)
		:setText("Credits")
		:setPosition(button_x, 128)
	,
	button:new(menu)
		:setText("Exit")
		:setPosition(button_x, 144)
		:set("active", love.event.quit)
	,
	header:new(menu)
		:setText("Roflnauts")
		:setPosition(width/2,40)
	,
}