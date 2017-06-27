local menu = ...

local Button = require "not.Button"
local Selector = require "not.Selector"
local Element = require "not.Element"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local naut_Selector = Selector(menu)
local start_Button = Button(menu)

require "iconsList"
local nautsIcons, nautsList = getNautsIconsList()

return {
	naut_Selector
		:setPosition(width/2,60)
		:setMargin(8)
		:setSize(32, 32)
		:set("list", nautsList)
		:set("global", false)
		:set("icons_i", love.graphics.newImage("assets/portraits.png"))
		:set("icons_q", nautsIcons)
		:init()
	,
	start_Button
		:setText("Force start")
		:setPosition(bx,134)
		:set("isEnabled", function ()
				if #naut_Selector:getFullSelection(false) > 1 then
					return true
				end
				return false
			end)
		:set("active", function (self)
				local nauts = naut_Selector:getFullSelection(false)
				if #nauts > 1 then
					changeScene(World(MAP, nauts))
				end
			end)
	,
	Button(menu)
		:setText("Go back")
		:setPosition(bx,150)
		:set("active", function (self)
				self.parent:open("host")
			end)
	,
	Element(menu)
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
				local total = #naut_Selector:getFullSelection(false)
				if total > 1 then
					self.the_final_countdown = self.the_final_countdown - dt
				else
					self.the_final_countdown = 9
				end
				if self.the_final_countdown < 0 then
					start_Button:active()
				end
			end)
	,
}