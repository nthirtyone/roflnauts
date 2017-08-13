local menu, background = ...

local Button = require "not.Button"
local Element = require "not.Element"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

return {
	background,
	Button(menu)
		:setText("Go back")
		:setPosition(bx,144)
		:set("active", function (self)
				self.parent:open("main")
			end)
	,
	Element(menu)
		:setPosition(width/2, 30)
		:set("draw", function (self, scale)
				local x,y = self:getPosition()
				love.graphics.printf("A game by the Awesomenauts community including:\nSeltzy, PlasmaWisp, ParaDoX, MilkingChicken, Burningdillo, Bronkey and Aki.\n\n04font was used.\n\nBased on a game by Jan Willem Nijman, Paul Veer and Bits_Beats XOXO.\n\nAwesomenauts is property of Ronimo Games.", (x-110)*scale, (y+10)*scale, 220, "left", 0, scale, scale)
			end)
	,
}
