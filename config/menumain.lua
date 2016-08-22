local menu = ...

local button = require "button"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local button_x = width/2-29

return {
	button:new(menu)
		:setText("start")
		:setPosition(button_x,60)
		:set("active", function ()
				changeScene(Menu:new("menustart"))
			end)
	,
	button:new(menu)
		:setText("join")
		:setPosition(button_x,76)
	,
	button:new(menu)
		:setText("settings")
		:setPosition(button_x,92)
	,
	button:new(menu)
		:setText("credits")
		:setPosition(button_x,108)
	,
	button:new(menu)
		:setText("exit")
		:setPosition(button_x,124)
		:set("active", love.event.quit)
	,
	button:new(menu)
		:setText("NEVER")
		:setPosition(button_x,140)
		:set("focus", function (self, next)
				if next then
					self.parent:next()
				else
					self.parent:previous()
				end
			end)
	,
}