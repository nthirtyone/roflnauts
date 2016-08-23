-- `Selector` (Element)
-- Used in Menu for selecting various things from list. Works for each Controller set or globally.
--[[
How to use `Selector` in `Menu` config file?
selector:new(menu)
	:setPosition(x, y)
	:set("list", require "file_with_list")
	:set("global", true/false) -- true: single selector; false: selector for each controller set present
]]

Selector = {
	parent,
	x = 0,
	y = 0,
	focused = false,
	global = false,
	list,
	sets,
	locks,
	selections
}

-- Constructor
function Selector:new(parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = parent
	o.list = {}
	o.sets = {}
	o.locks = {}
	o.selections = {}
	return o
end

-- Position
function Selector:getPosition()
	return self.x, self.y
end
function Selector:setPosition(x,y)
	self.x, self.y = x, y
	return self
end

-- General setter for Menu configuration files
function Selector:set(name, func)
	if type(name) == "string" and func ~= nil then
		self[name] = func
	end
	return self
end

-- Selecting functions
function Selector:getSelection(n) end
function Selector:next(n) end
function Selector:previous(n) end

-- Menu callbacks
function Selector:focus() -- Called when Element gains focus
	self.focused = true
	return true
end 
function Selector:blur() -- Called when Element loses focus
	self.focused = false
end 

-- LÖVE2D callbacks
function Selector:draw(scale) end
function Selector:update(dt) end

-- Controller callbacks
function Selector:controlpressed(set, action, key) end
function Selector:controlreleased(set, action, key) end

return Selector