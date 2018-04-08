require "not.Element"

--- `Header`
-- Swinging title.
Header = Element:extends()

Header.text = ""
Header.bounce = 2

function Header:new (parent)
	Header.__super.new(self, parent)
end

function Header:setText (text)
	self.text = text or ""
	return self
end

function Header:getBounce (f)
	local f = f or 1
	return math.sin(self.bounce*f*math.pi)
end

-- LÖVE2D callbacks
function Header:draw (scale)
		local angle = self:getBounce(2)
		local dy = self:getBounce()*4
		local x,y = self:getPosition()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(Bold)
		love.graphics.printf(string.upper(self.text),x*scale,(y+dy)*scale,400,"center",(angle*5)*math.pi/180,scale,scale,200,12)
end
function Header:update (dt)
	self.bounce = self.bounce + dt*0.7
	if self.bounce > Header.bounce then -- Header.bounce is initial
		self.bounce = self.bounce - Header.bounce
	end
end

return Header
