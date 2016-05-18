-- `Camera`
-- Used in drawing.

-- Metatable of `Camera`
Camera = {
	x = 0,
	y = 0,
	dest_x = 0,
	dest_y = 0,
	scale = 4,
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

-- Destination
function Camera:setDestination (x, y)
	local x = x or 0
	local y = y or 0
	self.dest_x, self.dest_y = x, y
end

function Camera:getDestination ()
	return self.dest_x, self.dest_y
end
	
-- Move follow
function Camera:follow ()
	local x,y,i = 105, 120, 1
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
	self:follow()
	local dx, dy = self:getDestination()
	dx = (dx - self.x) * 8 * dt
	dy = (dy - self.y) * 8 * dt
	self:setPosition(self.x + dx, self.y + dy)
end