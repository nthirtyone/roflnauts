-- `Sprite`
-- Abstract class for drawable animated entities.

-- Metatable
Sprite = {
	animations--[[table with animations]],
	current--[[animations.default]],
	image--[[love.graphics.newImage()]],
	frame = 1,
	delay = .1,
}
Sprite.__index = Sprite

-- Cleans up reference to image on deletion.
function Sprite:delete()
	self.image = nil
end

-- Sets an Image as a image.
function Sprite:setImage(image)
	self.image = image
end
-- Returns current image Image.
function Sprite:getImage()
	return self.image
end

-- Sets new animations list.
function Sprite:setAnimationsList(t)
	if t then
		self.animations = t
		self:setAnimation("default")
	end
end

-- Sets current animation by table key.
function Sprite:setAnimation(animation)
	self.frame = 1
	self.delay = Sprite.delay -- INITIAL from metatable
	self.current = self.animations[animation]
end
-- Returns current animation table.
function Sprite:getAnimation()
	return self.current
end

-- Get frame quad for drawing.
function Sprite:getQuad()
	if self.animations and self.current then
		return self.current[self.frame]
	end
end

-- Drawing self to LOVE2D buffer.
-- If there is no Quad, it will draw entire image.
function Sprite:draw(...)
	local s, q = self:getImage(), self:getQuad()
	if s then
		love.graphics.setColor(255,255,255,255)
		if q then love.graphics.draw(s, q, ...)
		else love.graphics.draw(s, ...) end
	end
end
-- Animation updating.
function Sprite:update(dt)
	if self.animations and self.current then
		self.delay = self.delay - dt
		if self.delay < 0 then
			self.delay = self.delay + Sprite.delay -- INITIAL from metatable
			self:nextFrame()
		end
	end
end
-- Moving to the next frame.
function Sprite:nextFrame()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	else
		self:setAnimation("default")
	end
end