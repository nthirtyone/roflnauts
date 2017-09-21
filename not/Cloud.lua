require "not.Decoration"

--- `Cloud`
-- That white thing moving in the background.
-- TODO: extends variables names to be readable.
Cloud = Decoration:extends()
Cloud.t = 1  -- type (sprite number)
Cloud.v = 13 -- velocity

-- TODO: allow maps to use other quads and sprites for clouds
-- TODO: you know this isn't right, don't you?
local animations = { 
	default = {
		[1] = love.graphics.newQuad(  1,  1, 158,47, 478,49),
		frames = 1,
		repeated = true
	},
	default2 = {
		[1] = love.graphics.newQuad(160,  1, 158,47, 478,49),
		frames = 1,
		repeated = true
	},
	default3 = {
		[1] = love.graphics.newQuad(319,  1, 158,47, 478,49),
		frames = 1,
		repeated = true
	}
}

-- Constructor of `Cloud`.
function Cloud:new (x, y, t, v, world)
	if self:getImage() == nil then
		self:setImage(Sprite.newImage("assets/clouds.png"))
	end
	Cloud.__super.new(self, x, y, world, nil)
	self:setAnimationsList(animations)
	self:setVelocity(v)
	self:setType(t)
end

-- Setters for cloud type and velocity.
function Cloud:setType (type)
	local animation = "default"
	if type > 1 then
		animation = animation .. type
	end
	self:setAnimation(animation)
	self.t = type
end
function Cloud:setVelocity (velocity)
	self.v = velocity
end

-- Update of `Cloud`, returns x for world to delete cloud after reaching right corner.
function Cloud:update (dt)
	Cloud.__super.update(self, dt)
	self.x = self.x + self.v*dt
	return self.x
end

return Cloud