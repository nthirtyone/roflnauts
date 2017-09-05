local menu, background = ...

local Button = require "not.Button"
local Selector = require "not.Selector"
local Element = require "not.Element"
local Group = require "not.Group"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local start_Button = Button(menu)

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

-- TODO: Temporary group for naut selectors. This isn't production code at any means!
local group, get
do
	local atlas = love.graphics.newImage("assets/portraits.png")
	local nauts = require("config.nauts")
	local icons = {}
	for i=0,#nauts-1 do
		table.insert(icons, love.graphics.newQuad(i*28, 0, 28, 27, 1008, 27))
	end

	group = Group(menu)

	local
	function attack (self)
		if not self.lock then
			if self.index == 1 then
				return
			end
			if self.index == 2 then
				self.index = self:rollRandom({1, 2})
			end
			if self:isUnique() then
				self.lock = true
			end
		end
	end

	for i,_ in pairs(Controller.getSets()) do
		group:addChild(Selector(nauts, group, menu))
			:set("icons_atlas", atlas)
			:set("icons_quads", icons)
			:set("attack", attack)
	end

	group:set("margin", 16)
	local gw, gh = group:getSize()
	group:setPosition((width - gw)/2, 55)

	function get ()
		local selection = group:callEach("getLocked")
		for i,naut in ipairs(selection) do
			selection[i] = {naut, Controller.getSets()[i]}
		end
		return selection
	end
end

return {
	background,
	group,
	start_Button
		:setText("Force start")
		:setPosition(bx,134)
		:set("isEnabled", function ()
				return #get() > 1
			end)
		:set("active", function (self)
				sceneManager:changeScene(World(MAP, get()))
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
				if #get() > 1 then
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
