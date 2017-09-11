--- Used in drawing other stuff in places.
Camera = require "not.Object":extends()

Camera.SHAKE_LENGTH = 0.6
Camera.SHAKE_INTERVAL = 0.03

-- TODO: Camera would really make use of vec2s (other classes would use them too).
function Camera:new (x, y, world)
	self.world = world
	self:setPosition(x, y)
	self:resetSum()
	self:initShake()
end

function Camera:initShake ()
	self.shakeTime = 0
	self.shakeInterval = 0
	self.shakeShift = {
		theta = love.math.random() * 2,
		radius = 0
	}
end

-- TODO: Even more magic numbers present in Camera. Translate method.
function Camera:translate (ratio)
	local x, y = self:getPositionScaled()
	local dx, dy = self:getShakeScaled()
	if ratio then
		dx = dx * ratio
		dy = dy * ratio
		x = x * ratio
		y = y * ratio
	end
	love.graphics.push()
	love.graphics.translate(160*getScale() - x - dx, 100*getScale() - y - dy)
end

function Camera:pop ()
	love.graphics.pop()
end

function Camera:setPosition (x, y)
	local x = x or 0
	local y = y or 0
	self.x, self.y = x, y
end

function Camera:getPosition ()
	return self.x, self.y
end

function Camera:getPositionScaled ()
	local scale = getScale()
	return self.x * scale, self.y * scale
end

-- TODO: Magic numbers present in camera's boundaries.
function Camera:getBoundaries ()
	local x, y = self:getPosition()
	return x - 160, y - 100, x + 160, y + 100
end

function Camera:getBoundariesScaled ()
	local x, y = self:getPositionScaled()
	local width, height = love.graphics.getDimensions()
	width = width / 2
	height = height / 2
	return x - width, y - height, x + width, y + height
end

-- TODO: Camera@scalePoints is left because PhysicalBody still uses it as love.graphics.scale is not used yet.
function Camera:scalePoints (...)
	local a, r, scale = {...}, {}, getScale()
	for _,v in pairs(a) do
		table.insert(r, v * scale)
	end
	return r
end

function Camera:startShake ()
	self.shakeTime = Camera.SHAKE_LENGTH
end

local
function limit (theta)
	if theta > 2 then
		return limitAngle(theta - 2)
	end
	if theta < 0 then
		return limitAngle(theta + 2)
	end
	return theta
end

-- TODO: Magic numbers present in Camera's shake.
function Camera:shake (dt)
	if self.shakeTime > 0 then
		self.shakeTime = self.shakeTime - dt
		if self.shakeInterval < 0 then
			self.shakeShift.theta = self.shakeShift.theta - 1.3 + love.math.random() * 0.6
			self.shakeShift.radius = 50 * self.shakeTime
			self.shakeInterval = Camera.SHAKE_INTERVAL
		else
			self.shakeShift.radius = self.shakeShift.radius * 0.66
			self.shakeInterval = self.shakeInterval - dt
		end
		if self.shakeTime < 0 then
			self.shakeShift.radius = 0
		end
	end
end

function Camera:getShake ()
	local radius = self.shakeShift.radius
	local theta = self.shakeShift.theta * math.pi
	return radius * math.cos(theta), radius * math.sin(theta)
end

function Camera:getShakeScaled ()
	local x, y = self:getShake()
	local scale = getScale()
	return x * scale, y * scale
end

function Camera:resetSum ()
	self.sumX = 0
	self.sumY = 0
	self.sumI = 0
end

function Camera:sum (x, y)
	local map = self.world.map
	if math.abs(x - map.center.x) < map.width/2 and
	   math.abs(y - map.center.y) < map.height/2 then
		self.sumX = self.sumX + x
		self.sumY = self.sumY + y
		self.sumI = self.sumI + 1
	end
end

function Camera:getSumPostion ()
	if self.sumI > 0 then
		return self.sumX / self.sumI, self.sumY / self.sumI
	end
	return 0, 0
end

function Camera:step (dt)
	local x, y = self:getSumPostion()
	local dx, dy = (x - self.x), (y - self.y)
	if math.abs(dx) > 0.4 or math.abs(dy) > 0.4 then
		x = self.x + (x - self.x) * dt * 6
		y = self.y + (y - self.y) * dt * 6
	end
	self:setPosition(x, y)
end

function Camera:update (dt)
	self:step(dt)
	self:shake(dt)
	self:resetSum()
end
