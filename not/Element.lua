--- `Element`
-- Empty element used inside `Menu`.
Element = {
	parent = --[[not.Menu]]nil,
	x = 0,
	y = 0
}

Element.__index = Element

function Element:new (parent)
	local o = setmetatable({}, self)
	o.parent = parent
	return o
end

function Element:delete () end -- deletes Element

function Element:getPosition ()
	return self.x, self.y
end
function Element:setPosition (x, y)
	self.x = x or 0
	self.y = y or 0
	return self
end

function Element:set (name, func)
	if type(name) == "string" and func ~= nil then
		self[name] = func
	end
	return self
end

-- Called when menu tries to focus on this element.
-- If it will return false then menu will skip element and go to next in list.
function Element:focus ()
	return false
end 
function Element:blur () end -- Called when Element loses focus.

-- LÖVE2D callbacks
function Element:draw (scale) end
function Element:update (dt) end

-- Controller callbacks
function Element:controlpressed (set, action, key) end
function Element:controlreleased (set, action, key) end

return Element
