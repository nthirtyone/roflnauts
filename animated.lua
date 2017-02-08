-- `Animated`
-- Abstract class for drawable animated entities.

-- Metatable
Animated = {
	animations--[[table with animations]],
	current--[[animations.default]],
	sprite--[[love.graphics.newImage()]],
	frame = 1,
	delay = .1,
}
Animated.__index = Animated

-- Cleans up reference to sprite on deletion.
function Animated:delete()
	self.sprite = nil
end

-- Sets an Image as a sprite.
function Animated:setSprite(image)
	self.sprite = image
end
-- Returns current sprite Image.
function Animated:getSprite()
	return self.sprite
end

-- Sets new animations list.
function Animated:setAnimationsList(t)
	if t then
		self.animations = t
		self:setAnimation("default")
	end
end

-- Sets current animation by table key.
function Animated:setAnimation(animation)
	self.frame = 1
	self.delay = Animated.delay -- INITIAL from metatable
	self.current = self.animations[animation]
end
-- Returns current animation table.
function Animated:getAnimation()
	return self.current
end

-- Get frame quad for drawing.
function Animated:getQuad()
	if self.animations and self.current then
		return self.current[self.frame]
	end
end

-- Drawing self to LOVE2D buffer.
-- If there is no Quad, it will draw entire sprite.
function Animated:draw(...)
	local s, q = self:getSprite(), self:getQuad()
	if s then
		love.graphics.setColor(255,255,255,255)
		if q then love.graphics.draw(s, q, ...)
		else love.graphics.draw(s, ...) end
	end
end
-- Animation updating.
function Animated:update(dt)
	if self.animations and self.current then
		self.delay = self.delay - dt
		if self.delay < 0 then
			self.delay = self.delay + Animated.delay -- INITIAL from metatable
			self:nextFrame()
		end
	end
end
-- Moving to the next frame.
function Animated:nextFrame()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	else
		self:setAnimation("default")
	end
end