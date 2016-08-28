local menu = ...

local button = require "button"
local element = require "element"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

return {
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,144)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
	element:new(menu)
		:setPosition(width/2, 30)
		:set("draw", function (self, scale)
				local x,y = self:getPosition()
				love.graphics.printf("The year is 3587. Conflict spans the stars as huge robot armies are locked in an enduring stalemate. In their bid for galactic supremacy, they call upon the most powerful group of mercenaries in the universe: the Awesomenauts!", (x-100)*scale, (y+10)*scale, 200, "center", 0, scale, scale)
			end)
	,
}