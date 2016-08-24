local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()

return {
	selector:new(menu)
		:setPosition(width/2,10)
		:setMargin(8)
		:setSize(32, 32)
		:set("list", require "nautslist")
		:set("global", false)
		:set("sprite", love.graphics.newImage("assets/portraits.png"))
		:set("quads", require "portraits")
		:init()
	,
	button:new(menu)
		:setText("Go back")
		:setPosition(10,height-25)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
}