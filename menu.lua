-- `Menu` (Scene)
-- It creates single screen of a menu
-- I do know that model I used here and in `World` loading configuration files is not flawless but I did not want to rewrite `World`s one but wanted to keep things similar at least in project scope.

require "music"

-- Here it begins
Menu = {
	scale = getScale(),
	elements, --table
	active = 1,
	music
}
function Menu:new(name)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.elements = {}
	o:load(name)
	o.music = Music:new("menu.ogg")
	return o
end
function Menu:delete() end

-- Load menu from file
function Menu:load(name)
	local name = "config/" .. (name or "menumain") .. ".lua"
	local menu = love.filesystem.load(name)
	self.elements = menu(self)
	self.elements[self.active]:focus()
end

-- Cycle elements
function Menu:next()
	self.elements[self.active]:blur()
	self.active = (self.active%#self.elements)+1
	if not self.elements[self.active]:focus() then
		self:next()
	end
end
function Menu:previous()
	self.elements[self.active]:blur()
	if self.active == 1 then
		self.active = #self.elements
	else
		self.active = self.active - 1
	end
	if not self.elements[self.active]:focus() then
		self:previous()
	end
end

-- LÖVE2D callbacks
function Menu:update(dt)
	for _,element in pairs(self.elements) do
		element:update(dt)
	end
end
function Menu:draw()
	local scale = self.scale
	love.graphics.setFont(Font)
	for _,element in pairs(self.elements) do
		element:draw(scale)
	end
end

-- Controller callbacks
function Menu:controlpressed(set, action, key)
	if action == "down" then
		self:next()
	end
	if action == "up" then
		self:previous()
	end
	for _,element in pairs(self.elements) do
		element:controlpressed(set, action, key)
	end
end
function Menu:controlreleased(set, action, key) end