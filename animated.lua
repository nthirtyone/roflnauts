-- `Animated`
-- Abstract class for animated entities.

-- Metatable
Animated = {
	animations = require "animations",
	current--[[animations.idle]], 
	frame = 1,
	delay = .1
}
Animated.__index = Animated
Animated.current = Animated.animations.idle

-- setAnimation(self, animation)
function Animated:setAnimation(animation)
	self.frame = 1
	self.delay = Animated.delay -- INITIAL from metatable
	self.current = self.animations[animation]
end

-- getAnimation(self)
function Animated:getAnimation()
	return self.current
end

-- animate(self, dt)
function Animated:animate(dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		self.delay = self.delay + Animated.delay -- INITIAL from metatable
		self:nextFrame()
	end
end

-- nextFrame(self)
function Animated:nextFrame()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	else
		self:setAnimation("idle")
	end
end