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

-- TODO: Clean-up menus/select, menus/host and Hero after portraits split.
local group, get
do
	local nauts, icons = {}, {}
	local files = love.filesystem.getDirectoryItems("config/nauts")
	for _,filename in pairs(files) do
		local path = string.format("config/nauts/%s", filename)
		if love.filesystem.isFile(path) and filename ~= "readme.md" then
			local naut = love.filesystem.load(path)()
			local i, name = naut.portrait, naut.name
			if naut.available then
				table.insert(icons, love.graphics.newImage(naut.portrait))
				table.insert(nauts, naut)
			end
		end
	end

	-- TODO: Find a better way to add empty and random entries to naut Selector.
	table.insert(icons, 1, false)
	table.insert(nauts, 1, {name = "empty"})
	table.insert(icons, 2, love.graphics.newImage("assets/portraits/random.png"))
	table.insert(nauts, 2, {name = "random"})

	group = Group(menu)

	local
	function attack (self)
		if not self.lock then
			local selected = self:getSelected()
			if selected.name == "empty" then
				return
			end
			if selected.name == "random" then
				self.index = self:rollRandom({1, 2})
			end
			if self:isUnique() then
				self.lock = true
			end
		end
	end

	for i,_ in pairs(Controller.getSets()) do
		group:addChild(Selector(nauts, group, menu))
			:set("icons", icons)
			:set("attack", attack)
			:set("getText", function (self)
					return string.upper(self:getSelected().name)
				end)
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
