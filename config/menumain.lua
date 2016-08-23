local menu = ...

local button = require "button"
local header = require "header"
local element = require "element"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local button_x = width/2-29

return {
	button:new(menu)
		:setText("Start")
		:setPosition(button_x, 80)
		:set("active", function (self)
				self.parent:load("menuselect")
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
	element:new(menu)
		:setPosition(width/2, 15)
		:set("draw", function (self, scale) 
				local x,y = self:getPosition()
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.setFont(Bold)
				love.graphics.print("1", (x-17)*scale, y*scale, 0, scale*2, scale*2, 12)
				love.graphics.print("1", (x+13)*scale, y*scale, 0, scale*2, scale*2, 12)
			end)
	,
	header:new(menu)
		:setText("Roflnauts")
		:setPosition(width/2,40)
	,
}