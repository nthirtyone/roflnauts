-- `Effect`
-- Short animation with graphics that plays in various situation.

-- Metatable of `Effect`
-- nils initialized in constructor
-- TODO: inherit from `not.Sprite`.
-- TODO: clean-up and reformat code, see newer code for reference.
Effect = {
	x = 0,
	y = 0,
	delay = 0.06,
	initial = nil,
	frame = 1,
	animation = nil,
	sprite = nil,
	quads = require "effects"
}

-- Construct of `Effect`
function Effect:new(name, x, y)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Load spritesheet to metatable if not yet loaded
	if self.sprite == nil then
		self.sprite = love.graphics.newImage("assets/effects.png")
	end
	-- Init
	o.initial = o.delay
	o.animation = name
	o.x = x or self.x
	o.y = y or self.y
	return o
end

-- Position
function Effect:getPosition()
	return self.x, self.y
end

-- Animation and return flag for deletion after completion
-- returns true if completed and ready to delete
function Effect:update(dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		if self.frame < self.quads[self.animation].frames then
			self.frame = self.frame + 1
			self.delay = self.delay + self.initial
		else
			return true -- delete
		end
	end
	return false
end

-- Draw me with scale and offsets, senpai
function Effect:draw(offset_x, offset_y, scale)
	-- locals
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	local scale = scale or 1
	local x, y = self:getPosition()
	-- pixel grid
	local draw_x = (math.floor(x) + offset_x) * scale
	local draw_y = (math.floor(y) + offset_y) * scale
	-- draw
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.sprite, self.quads[self.animation][self.frame], draw_x, draw_y, 0, scale, scale)
end