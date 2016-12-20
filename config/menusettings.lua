local menu = ...

local button = require "button"
local selector = require "selector"
local element = require "element"

local width, height = love.graphics.getWidth()/getRealScale(), love.graphics.getHeight()/getRealScale()
local bx = width/2-29

local keys = {"Left", "Right", "Up", "Down", "Attack", "Jump"}

local dimmer = element:new(menu)
	:setPosition(width/2, 15)
	:set("visible", false)
	:set("currentControl", "Left")
	:set("draw", function (self, scale) 
			if self.visible then
				love.graphics.setColor(0, 0, 0, 210)
				love.graphics.rectangle("fill",0,0,width*getRealScale(),height*getRealScale())
				love.graphics.setColor(120, 255, 120, 255)
				love.graphics.printf("Press new key for: \n> " .. self.currentControl .. " <", (width/2-110)*scale, (height/2-4)*scale, 220, "center", 0, scale, scale)
				love.graphics.setColor(255, 255, 255, 255)
			end
		end)

-- CHANGER functions
local isEnabled = function (self)
	if Controller.getSets()[self.setNumber()] and not self.inProgress then
		return true
	else
		return false
	end
end
local startChange = function (self)
	dimmer:set("visible", true):set("currentControl", "Left")
	self.parent.allowMove = false
	self.inProgress = true
	self.currentKey = 0
	self.newSet = {}
end
local controlreleased = function(self, set, action, key)
	if self.inProgress then
		if self.currentKey > 0 and self.currentKey < 7 then
			table.insert(self.newSet, key)
			dimmer:set("currentControl", keys[self.currentKey+1])
		end
		if self.currentKey > 5 then
			dimmer:set("visible", false)
			self.parent.allowMove = true
			self.inProgress = false
			table.insert(self.newSet, Controller.sets[self.setNumber()][7])
			print(self.newSet[7])
			Settings.change(self.setNumber(), self.newSet[1], self.newSet[2], self.newSet[3], self.newSet[4], self.newSet[5], self.newSet[6], self.newSet[7])
		else
			self.currentKey = self.currentKey + 1
		end
	end
end

local a = {
	button:new(menu)
		:setText("Keyboard 1")
		:setPosition(bx,80)
		:set("setNumber", function () return 1 end)
		:set("isEnabled", isEnabled)
		:set("controlreleased", controlreleased)
		:set("stopChange", stopChange)
		:set("active", startChange)
	,
		button:new(menu)
		:setText("Keyboard 2")
		:setPosition(bx,96)
		:set("setNumber", function () return 2 end)
		:set("isEnabled", isEnabled)
		:set("controlreleased", controlreleased)
		:set("stopChange", stopChange)
		:set("active", startChange)
	,
		button:new(menu)
		:setText("Gamepad 1")
		:setPosition(bx,112)
		:set("setNumber", function () return 3 end)
		:set("isEnabled", isEnabled)
		:set("controlreleased", controlreleased)
		:set("stopChange", stopChange)
		:set("active", startChange)
	,
	button:new(menu)
		:setText("Gamepad 2")
		:setPosition(bx,128)
		:set("setNumber", function () return 4 end)
		:set("isEnabled", isEnabled)
		:set("controlreleased", controlreleased)
		:set("stopChange", stopChange)
		:set("active", startChange)
	,
	button:new(menu)
		:setText("Go back")
		:setPosition(bx,144)
		:set("active", function (self)
				self.parent:load("menumain")
			end)
	,
	dimmer
}

return a