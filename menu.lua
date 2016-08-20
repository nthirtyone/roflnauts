-- `Menu` (Scene)
-- It creates single screen of a menu

require "selector"
require "button"

-- Here it begins
Menu = {
	scale = getScale(),
	elements, --table
	active = 1
}
function Menu:new(name)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.elements = {}
	o:load(name)
	return o
end
function Menu:delete() end

-- Load menu from file
function Menu:load(name)
	local name = "config/" .. (name or "menumain") .. ".lua"
	print(name)
	local menu = love.filesystem.load(name)
	self.elements = menu()
end

-- Creators
function Menu:newButton()
	local button = Button:new()
end

-- LÖVE2D callbacks
function Menu:update(dt) end
function Menu:draw()
	local scale = self.scale
	love.graphics.setFont(Font)
	for i,v in ipairs(self.elements) do
		if self.active == i then
			love.graphics.setColor(255, 128, 0, 255)
		else 
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.print(v, 10, (80-5*#self.elements+10*i)*scale, 0, scale, scale)
	end
end

-- Controller callbacks
function Menu:controlpressed(set, action, key)
	if action == "down" then
		self.active = (self.active%#self.elements)+1
	end
	if action == "up" then
		if self.active == 1 then
			self.active = #self.elements
		else
			self.active = self.active - 1
		end
	end
end
function Menu:controlreleased(set, action, key) end