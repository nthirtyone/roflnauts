-- `Selector` (Element)
-- Used in Menu for selecting various things from list. Works for each Controller set or globally.
--[[
How to use `Selector` in `Menu` config file?
selector:new(menu)
	:setPosition(x, y)
	:set("list", require "file_with_list")
	:set("global", true/false) -- true: single selector; false: selector for each controller set present
	:init()
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

-- Initialize Selector with current settings.
function Selector:init()
	-- Make sure that there is list present
	if self.list == nil then
		self.list = {}
	end
	-- Initialize global Selector
	if self.global then
		self.locks = {false}
		self.selections = {1}
	-- Initialize Selector for Controllers
	else
		self.sets = Controller.getSets()
		self.locks = {}
		self.selections = {}
		for i=1,#self.sets do
			self.locks[i] = false
			self.selections[i] = 1
		end
	end
end

-- Cycle through list on given number
function Selector:next(n) end
function Selector:previous(n) end

-- Get number associated with a given set
function Selector:checkNumber(set)
	if self.global then return 1 end -- For global Selector
	for n,check in pairs(self.sets) do
		if check == set then return n end
	end
end

-- Check if given number is locked
function Selector:isLocked(n)
	return self.locks[n]
end

-- Get value of selection of given number
function Selector:getSelectionValue(n)
	return self.selections[n]
end

-- Get value from list by selection
function Selector:getListValue(i)
	return self.list[i]
end

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