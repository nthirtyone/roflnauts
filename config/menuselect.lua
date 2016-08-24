local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()

return {
	selector:new(menu)
		:setPosition(10,10)
		:setSpacing(42, 0)
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