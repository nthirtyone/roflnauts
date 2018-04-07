local menu = ...

local Button = require "not.Button"
local Element = require "not.Element"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

return {
	Element(menu)
		:set("draw", function (self, scale)
				love.graphics.setColor(0, 0, 0, .45)
				local width, height = love.graphics.getWidth(), love.graphics.getHeight()
				love.graphics.rectangle("fill", 0, 0, width, height)
			end)
	,
	Button(menu)
		:setText("Unpause")
		:setPosition(bx, height - 38)
		:set("active", function (self)
				sceneManager:removeTopScene()
				local scene = sceneManager:getAllScenes()[1]
				scene:setSleeping(false)
				scene:setInputDisabled(false)
			end)
	,
	Button(menu)
		:setText("Exit")
		:setPosition(bx, height - 22)
		:set("active", function (self)
				sceneManager:removeTopScene()
				sceneManager:changeScene(Menu("main"))
			end)
	,
}
