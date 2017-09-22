--- Used in drawing other stuff in places.
-- TODO: Camera is missing documentation on every important method.
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

function Camera:push ()
	love.graphics.push()
end

function Camera:transform (scale, ratio, vw, vh)
	local px, py = self:getPosition()
	local sx, sy = self:getShake()
	local dx, dy = math.floor((px + sx) * ratio), math.floor((py + sy) * ratio)

	vw, vh = math.floor(vw / scale / 2), math.floor(vh / scale / 2)

	love.graphics.scale(scale, scale)
	love.graphics.translate(vw - dx, vh - dy)
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

function Camera:getBoundaries (scale, vw, vh)
	local x, y = self:getPosition()
	local width, height = vw / scale / 2, vh / scale / 2
	return x - width, y - height, x + width, y + height
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
