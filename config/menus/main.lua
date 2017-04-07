local menu = ...

local button = require "not.Button"
local header = require "not.Header"
local element = require "not.Element"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local awesometwo = love.graphics.newImage("assets/two.png")

return {
	button:new(menu)
		:setText("Start")
		:setPosition(bx, 80)
		:set("active", function (self)
				self.parent:open("host")
			end)
	,
	button:new(menu)
		:setText("Join")
		:setPosition(bx, 96)
		:set("isEnabled", function (self)
				return false
			end)
	,
	button:new(menu)
		:setText("Settings")
		:setPosition(bx, 112)
		:set("active", function (self)
				self.parent:open("settings")
			end)
	,
	button:new(menu)
		:setText("Credits")
		:setPosition(bx, 128)
		:set("active", function (self)
				self.parent:open("credits")
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
				love.graphics.draw(awesometwo, x*scale, y*scale, 0, scale, scale, 35)
			end)
	,
	header:new(menu)
		:setText("Roflnauts")
		:setPosition(width/2,40)
	,
}