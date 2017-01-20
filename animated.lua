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
	return self.current[self.frame]
end

-- Drawing self to LOVE2D buffer.
function Animated:draw(...)
	local s, q = self:getSprite(), self:getQuad()
	if s and q then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(s, q, ...)
	end
end
-- Animation updating.
function Animated:update(dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		self.delay = self.delay + Animated.delay -- INITIAL from metatable
		self:nextFrame()
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