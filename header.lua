-- `Header`
-- It dances!

Header = {
	x = 0,
	y = 0,
	text = "",
	parent,
	bounce = 2,
}
function Header:new(parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = parent
	return o
end
function Header:setText(text)
	self.text = text or ""
	return self
end
function Header:setPosition(x, y)
	self.x = x or 0
	self.y = y or 0
	return self
end
function Header:getBounce(f)
	local f = f or 1
	return math.sin(self.bounce*f*math.pi)
end
function Header:getPosition() return self.x,self.y end -- gives x,y of Element
function Header:focus()
	return false
end
function Header:blur() end -- Called when Element loses focus

-- LÖVE2D callbacks
function Header:draw(scale)
		local angle = self:getBounce(2)
		local dy = self:getBounce()*4
		local x,y = self:getPosition()
		love.graphics.setColor(255,255,255,255)
		love.graphics.setFont(Bold)
		love.graphics.printf(string.upper(self.text),x*scale,(y+dy)*scale,400,"center",(angle*5)*math.pi/180,scale,scale,200,12)
end
function Header:update(dt)
	self.bounce = self.bounce + dt*0.7
	if self.bounce > Header.bounce then -- Header.bounce is initial
		self.bounce = self.bounce - Header.bounce
	end
end

-- Controller callbacks
function Header:controlpressed(set, action, key) end
function Header:controlreleased(set, action, key) end

return Header