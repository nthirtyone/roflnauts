local menu = ...

local button = require "button"
local selector = require "selector"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

local naut_selector = selector:new(menu)

return {
	naut_selector
		:setPosition(width/2,60)
		:setMargin(8)
		:setSize(32, 32)
		:set("list", require "nautslist")
		:set("global", false)
		:set("sprite", love.graphics.newImage("assets/portraits.png"))
		:set("quads", require "portraits")
		:init()
	,
	button:new(menu)
		:setText("Force start")
		:setPosition(bx,101)
		:set("active", function (self)
				changeScene(World:new(nil,naut_selector:getFullSelection(false)))
			end)
	,
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,117)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
}