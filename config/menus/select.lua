local menu, background = ...

local Button = require "not.Button"
local Selector = require "not.Selector"
local Element = require "not.Element"
local Group = require "not.Group"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

local startButton = Button(menu)

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

-- TODO: loadConfigs and isAvailable are duplicated in menus/select and menus/host.
local
function isAvailable (item)
	if item then
		if debug then
			return true
		end
		local at = type(item.available)
		if at == "boolean" then
			return item.available
		end
		if at == "string" then
			return false
		end
	end
end

local
function loadConfigs (dir, process)
	local items, icons = {}, {}
	for _,file in pairs(love.filesystem.getDirectoryItems(dir)) do
		local path = string.format("%s/%s", dir, file)
		if love.filesystem.getInfo(path).type == "file" and file ~= "readme.md" then
			local item = love.filesystem.load(path)()
			if isAvailable(item) then
				if process then
					process(item, file, path)
				end
				table.insert(icons, love.graphics.newImage(item.portrait))
				table.insert(items, item)
			end
		end
	end
	return items, icons
end

-- TODO: Clean-up menus/select, menus/host and Hero after portraits split.
local group, get
do
	local nauts, icons = loadConfigs("config/nauts")

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
	startButton
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
					startButton:active()
				end
			end)
	,
}
