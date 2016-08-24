local menu = ...

local button = require "button"
local header = require "header"
local element = require "element"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

return {
	button:new(menu)
		:setText("Start")
		:setPosition(bx, 80)
		:set("active", function (self)
				self.parent:load("menuhost")
			end)
	,
	button:new(menu)
		:setText("Join")
		:setPosition(bx, 96)
		:set("active", function (self)
				self:blink()
			end)
	,
	button:new(menu)
		:setText("Settings")
		:setPosition(bx, 112)
		:set("active", function (self)
				self:blink()
			end)
	,
	button:new(menu)
		:setText("Credits")
		:setPosition(bx, 128)
		:set("active", function (self)
				self:blink()
			end)
	,
	button:new(menu)
		:setText("Exit")
		:setPosition(bx, 144)
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