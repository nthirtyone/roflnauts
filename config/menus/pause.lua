local menu = ...

local Button = require "not.Button"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

return {
	Button(menu)
		:setText("Unpause")
		:setPosition(bx, height - 36)
		:set("active", function () end)
	,
	Button(menu)
		:setText("Exit")
		:setPosition(bx, height - 20)
		:set("active", function () end)
	,
}
