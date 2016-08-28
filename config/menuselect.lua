local menu = ...

local button = require "button"
local selector = require "selector"
local element = require "element"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

local naut_selector = selector:new(menu)
local start_button = button:new(menu)

return {
	naut_selector
		:setPosition(width/2,60)
		:setMargin(8)
		:setSize(32, 32)
		:set("list", require "nautslist")
		:set("global", false)
		:set("icons_i", love.graphics.newImage("assets/portraits.png"))
		:set("icons_q", require "nautsicons")
		:init()
	,
	start_button
		:setText("Force start")
		:setPosition(bx,134)
		:set("isEnabled", function ()
				if #naut_selector:getFullSelection(false) > 1 then
					return true
				end
				return false
			end)
		:set("active", function (self)
				local nauts = naut_selector:getFullSelection(false)
				if #nauts > 1 then
					changeScene(World:new(MAP, nauts))
				end
			end)
	,
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,150)
		:set("active", function (self)
				self.parent:load("menuhost")
			end)
	,
	element:new(menu)
		:setPosition(bx, 101)
		:set("the_final_countdown", 9)
		:set("draw", function (self, scale)
				if self.the_final_countdown ~= 9 then
					local x,y = self:getPosition()
					local countdown = math.max(1, math.ceil(self.the_final_countdown))
					love.graphics.setColor(255, 255, 255, 255)
					love.graphics.setFont(Font)
					love.graphics.print("Autostart in:", (x-16)*scale, (y+10)*scale, 0, scale, scale)
					love.graphics.setFont(Bold)
					love.graphics.printf(countdown, (x+40)*scale, (y)*scale, 36, "center", 0, scale, scale)
				end
			end)
		:set("update", function (self, dt)
				local total = #naut_selector:getFullSelection(false)
				if total > 1 then
					self.the_final_countdown = self.the_final_countdown - dt
				else
					self.the_final_countdown = 9
				end
				if self.the_final_countdown < 0 then
					start_button:active()
				end
			end)
	,
}