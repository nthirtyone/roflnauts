local menu = ...

local Header = require "not.Header"
local Element = require "not.Element"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()

return {
	Element(menu)
		:setPosition(width/2, 18)
		:set("draw", function (self, scale) 
				local x,y = self:getPosition()
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.printf("rofl, now kill yourself", x*scale, y*scale, 160, "center", 0, scale, scale, 80, 3)
			end)
		:set("focus", function () return true end)
	,
	Header(menu)
		:setText("WINNER")
		:setPosition(width/2,40)
	,
}
