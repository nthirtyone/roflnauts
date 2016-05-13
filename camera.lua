-- `Camera`
-- Used in drawing.

-- Metatable of `Camera`
Camera = {
	x = 0,
	y = 0,
	follow = nil
}

-- Constructor of `Camera`
function Camera:new ()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.follow = {}
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

-- Add follow position
function Camera:addFollow (x, y, w)
	local w = 1
	if x ~= nil and y ~= nil then
		table.insert(self.follow, {["x"] = x, ["y"] = y, ["w"] = w})
	end
end

-- Move follow
function Camera:moveFollow ()
	local x,y,i = 145, 90, 1
	for k,point in pairs(Nauts) do
		i = i + 1
		x = math.max(math.min(point.body:getX(),290),0) + x
		y = math.max(math.min(point.body:getY(),180),0) + y
	end
	x = x / i - 145
	y = y / i - 90
	self:setPosition(x,y)
end