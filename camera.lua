-- `Camera`
-- Used in drawing.

-- Metatable of `Camera`
Camera = {
	x = 0,
	y = 0,
	dest_x = 0,
	dest_y = 0,
	scale = 4,
	shake = 0,
	timer = 0,
	delay = 0,
	origin_x = 0,
	origin_y = 0,
	shake_x = 0,
	shake_y = 0,
	world = nil, --  game world
}

-- Constructor of `Camera`
function Camera:new (world)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.world = world
	return o
end

-- Drawing offsets
function Camera:getOffsets ()
	return -self.x,-self.y
end

-- Position
function Camera:setPosition (x, y)
	local x = x or 0
	local y = y or 0
	self.x, self.y = x, y
end

function Camera:getPosition ()
	return self.x, self.y
end

-- Destination
function Camera:setDestination (x, y)
	local x = x or 0
	local y = y or 0
	self.dest_x, self.dest_y = x, y
end

function Camera:getDestination ()
	return self.dest_x, self.dest_y
end
	
-- Shake it
-- Really bad script, but for now it works
function Camera:shake ()
	if self.shake_x == 0 then
		self.shake_x = math.random(-10, 10) * 2
	elseif self.shake_x > 0 then
		self.shake_x = math.random(-10, -1) * 2
	elseif self.shake_x < 0 then
		self.shake_x = math.random(10, 1) * 2
	end
	if self.shake_y == 0 then
		self.shake_y = math.random(-10, 10) * 2
	elseif self.shake_y > 0 then
		self.shake_y = math.random(-10, -1) * 2
	elseif self.shake_y < 0 then
		self.shake_y = math.random(10, 1) * 2
	end
	local x = self.origin_x + self.shake_x
	local y = self.origin_y + self.shake_y
	self:setDestination(x, y)
end

function Camera:startShake ()
	self.timer = 0.3
	self.origin_x, self.origin_y = self:getPosition()
end

-- Move follow
function Camera:follow ()
	local x,y,i = 145, 90, 1
	for k,point in pairs(self.world.Nauts) do
		if point.body:getX() > -20 and point.body:getX() < 310 and
		   point.body:getY() > -70 and point.body:getY() < 200 then
			i = i + 1
			x = point.body:getX() + x
			y = point.body:getY() + y
		end
	end
	x = x / i - 145
	y = y / i - 90
	self:setDestination(x,y)
end

-- Update
function Camera:update (dt)
	if self.timer > 0 then
		self.timer = self.timer - dt
		if self.delay <= 0 then
			self:shake()
			self.delay = 0.02
		else
			self.delay = self.delay - dt
		end
	else
		self:follow()
	end
	local dx, dy = self:getDestination()
	dx = (dx - self.x) * 6 * dt
	dy = (dy - self.y) * 6 * dt
	self:setPosition(self.x + dx, self.y + dy)
end
