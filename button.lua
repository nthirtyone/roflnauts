-- `Button`
-- Button used in `Menu`

Button = {
	text = "button",
	focused = false,
	x = 0,
	y = 0
}

function Button:new(text)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.text = text or self.text
	return o
end
function Button:setPosition(x, y)
	self.x = x or 0
	self.y = y or 0
	return self
end
function Button:getPosition() return self.x,self.y end
function Button:focus()
	self.focused = true
end
function Button:blur()
	self.focused = false
end
function Button:active() end
function Button:set(name, func)
	if type(name) == "string" and type(func) == "function" then
		self[name] = func
	end
	return self
end
function Button:draw(scale)
	local x,y = self:getPosition()
	if self.focused then
		love.graphics.setColor(255, 128, 0, 255)
	else 
		love.graphics.setColor(255, 255, 255, 255)
	end
	love.graphics.print(self.text, x*scale, y*scale, 0, scale, scale)
end
function Button:update(dt) end
function Button:controlpressed(set, action, key)
	if action == "attack" and self.focused then
		self:active()
	end
end
function Button:controlreleased(set, action, key) end

return Button