--- `Camera`
-- Used in drawing.
Camera = {
	x = 0,
	y = 0,
	dest_x = 0,
	dest_y = 0,
	shake = 0,
	timer = 0,
	delay = 0,
	origin_x = 0,
	origin_y = 0,
	shake_x = 0,
	shake_y = 0,
	world = --[[not.World]]nil,
}

-- Constructor of `Camera`
function Camera:new (world)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.world = world
	o:setPosition(o:follow())
	o:setDestination(o:follow())
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

function Camera:getPositionScaled ()
	return self.x*getScale(), self.y*getScale()
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

-- Translate points
function Camera:translatePosition (x, y)
	local x = x or 0
	local y = y or 0
	return (x-self.x)*getScale(), (y-self.y)*getScale()
end

function Camera:translatePoints(...)
	local a = {...}
	local r = {}
	local x,y = self:getOffsets()
	for k,v in pairs(a) do
		if k%2 == 1 then
			table.insert(r, (v + x) * getScale())
		else
			table.insert(r, (v + y) * getScale())
		end
	end
	return r
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
	local map = self.world.map
	local sum_x,sum_y,i = map.center_x, map.center_y, 1
	for k,naut in pairs(self.world.Nauts) do
		local naut_x,naut_y = naut:getPosition()
		if math.abs(naut_x - map.center_x) < map.width/2 and
		   math.abs(naut_y - map.center_y) < map.height/2 then
			i = i + 1
			sum_x = naut_x + sum_x
			sum_y = naut_y + sum_y
		end
	end
	local x = sum_x / i - love.graphics.getWidth()/getScale()/2
	local y = sum_y / i - love.graphics.getHeight()/getScale()/2 + 4*getScale() -- hotfix
	return x,y
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
		self:setDestination(self:follow())
	end
	local dx, dy = self:getDestination()
	dx = (dx - self.x) * 6 * dt
	dy = (dy - self.y) * 6 * dt
	self:setPosition(self.x + dx, self.y + dy)
end
