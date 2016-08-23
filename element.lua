-- `Element`
-- Empty element for `Menu` creation. Can be anything.
Element = {
	x = 0,
	y = 0,
	parent
}
function Element:new(parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = parent
	return o
end
function Element:delete() end -- deletes Element
function Element:getPosition() return self.x, self.y end -- gives x,y of Element
function Element:setPosition(x,y)
	self.x, self.y = x, y
	return self
end
function Element:set(name, func)
	if type(name) == "string" and func ~= nil then
		self[name] = func
	end
	return self
end

-- Menu callbacks
function Element:focus(next) -- Called when Element gains focus
	if next and self.parent then
		self.parent:next()
	else
		self.parent:previous()
	end
end 
function Element:blur() end -- Called when Element loses focus

-- LÖVE2D callbacks
function Element:draw(scale) end
function Element:update(dt) end

-- Controller callbacks
function Element:controlpressed(set, action, key) end
function Element:controlreleased(set, action, key) end

return Element