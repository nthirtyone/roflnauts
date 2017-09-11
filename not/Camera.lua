--- Used in drawing other stuff in places.
Camera = require "not.Object":extends()

Camera.SHAKE_LENGTH = 0.8
Camera.SHAKE_INTERVAL = 0.04

-- TODO: Camera would really make use of vec2s (other classes would use them too).
function Camera:new (world)
	self.world = world

	self.x = 0
	self.y = 0
	self.dest_y = 0
	self.dest_x = 0
	self.origin_x = 0
	self.origin_y = 0

	self:setPosition(self:follow())
	self:setDestination(self:follow())

	self.shakeTime = 0
	self.shakeInterval = 0
	self.shakeShift = {
		theta = love.math.random() * 2,
		radius = 0
	}
end

function Camera:translate ()
	local x, y = self:getPositionScaled()
	local dx, dy = self:getShakeShift()
	love.graphics.push()
	love.graphics.translate(-x - dx, -y - dy)
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

function Camera:setDestination (x, y)
	local x = x or 0
	local y = y or 0
	self.dest_x, self.dest_y = x, y
end

function Camera:getDestination ()
	return self.dest_x, self.dest_y
end

function Camera:translatePosition (x, y)
	local x = x or 0
	local y = y or 0
	return (x-self.x)*getScale(), (y-self.y)*getScale()
end

function Camera:translatePoints (...)
	local a = {...}
	local r = {}
	local x,y = 0,0
	for k,v in pairs(a) do
		if k%2 == 1 then
			table.insert(r, (v + x) * getScale())
		else
			table.insert(r, (v + y) * getScale())
		end
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
			self.shakeShift.radius = 80 * self.shakeTime
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

function Camera:getShakeShift ()
	local radius = self.shakeShift.radius
	local theta = self.shakeShift.theta * math.pi
	return radius * math.cos(theta), radius * math.sin(theta)
end

function Camera:follow ()
	local map = self.world.map
	local sum_x,sum_y,i = map.center.x, map.center.y, 1
	for k,naut in pairs(self.world:getNautsAll()) do
		local naut_x,naut_y = naut:getPosition()
		if math.abs(naut_x - map.center.x) < map.width/2 and
		   math.abs(naut_y - map.center.y) < map.height/2 then
			i = i + 1
			sum_x = naut_x + sum_x
			sum_y = naut_y + sum_y
		end
	end
	local x = sum_x / i - love.graphics.getWidth()/getScale()/2
	local y = sum_y / i - love.graphics.getHeight()/getScale()/2 + 4*getScale() -- hotfix
	return x,y
end

function Camera:update (dt)
	self:shake(dt)
	self:setDestination(self:follow())
	local dx, dy = self:getDestination()
	dx = (dx - self.x) * 6 * dt
	dy = (dy - self.y) * 6 * dt
	self:setPosition(self.x + dx, self.y + dy)
end
