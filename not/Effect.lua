--- `Effect`
-- Short animation with graphics that plays in various situation.
-- TODO: animation is currently slower than it used to be, check if it is ok; if not then make it possible to change it to 0.06 delay.
Effect = {
	finished = false,
}

-- `Effect` is a child of `Decoration`.
require "not.Decoration"
Effect.__index = Effect
setmetatable(Effect, Decoration)

-- Constructor of `Effect`.
function Effect:new (name, x, y)
	local o = setmetatable({}, self)
	o:init(name, x, y)
	-- Load spritesheet statically.
	if self:getImage() == nil then
		self:setImage(Sprite.newImage("assets/effects.png"))
	end
	return o
end

-- Initializer of `Effect`.
function Effect:init (name, x, y)
	Decoration.init(self, x, y, nil)
	self:setAnimationsList(require("config.animations.effects"))
	self:setAnimation(name)
end

-- Update of `Effect`.
-- Returns true if animation is finished and effect is ready to be deleted.
function Effect:update (dt)
	Decoration.update(self, dt)
	return self.finished
end

-- Overridden from `not.Sprite`.
-- Sets finished flag if reached last frame of played animation.
function Effect:goToNextFrame ()
	if not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	else
		self.finished = true
	end
end
