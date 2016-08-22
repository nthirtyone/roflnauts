-- `Button`
-- Button used in `Menu`

Button = {
	text = "",
	focused = false,
	x = 0,
	y = 0,
	sprite,
	quad = love.graphics.newQuad(0, 0, 58,15, 68,15),
	arrow_l = love.graphics.newQuad(58, 0, 5, 5, 68,15),
	arrow_r = love.graphics.newQuad(63, 0, 5, 5, 68,15),
	delay = 2,
	parent
}

function Button:new(parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = parent
	self.sprite = love.graphics.newImage("assets/menu.png")
	return o
end
function Button:setText(text)
	self.text = text or ""
	return self
end
function Button:setPosition(x, y)
	self.x = x or 0
	self.y = y or 0
	return self
end
function Button:getPosition() return self.x,self.y end
function Button:focus(next)
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
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.sprite, self.quad, x*scale, y*scale, 0, scale, scale)
	if self.focused then
		love.graphics.draw(self.sprite, self.arrow_l, (x+54+math.floor(self.delay))*scale, (y+5)*scale, 0, scale, scale)
		love.graphics.draw(self.sprite, self.arrow_r, (x-1-math.floor(self.delay))*scale, (y+5)*scale, 0, scale, scale)
	end
	love.graphics.printf(string.upper(self.text), (x+2)*scale, (y+4)*scale, 54, "center", 0, scale, scale)
end
function Button:update(dt)
	self.delay = (self.delay + dt)%Button.delay -- Button.delay is initial
end
function Button:controlpressed(set, action, key)
	if action == "attack" and self.focused then
		self:active()
	end
end
function Button:controlreleased(set, action, key) end

return Button