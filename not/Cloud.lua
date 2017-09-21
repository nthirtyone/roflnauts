--- `Cloud`
-- Moving decorations with limited lifespan.
Cloud = require "not.Decoration":extends()

function Cloud:new (x, y, world, imagePath)
	Cloud.__super.new(self, x, y, world, imagePath)
	self.velocity_x = 0
	self.velocity_y = 0
	self.boundary_x = 0
	self.boundary_y = 0
end

function Cloud:setVelocity (x, y)
	self.velocity_x = x
	self.velocity_y = y
end

function Cloud:setBoundary (x, y)
	self.boundary_x = x
	self.boundary_y = y
end

function Cloud:setStyle (style)
	self:setAnimation(style)
end

function Cloud:getStyle ()
	return self:getAnimation()
end

function Cloud:testPosition ()
	if self.x > self.boundary_x or self.y > self.boundary_y then
		return true
	end
end

-- Cloud will get deleted if this function returns true.
function Cloud:update (dt)
	Cloud.__super.update(self, dt)
	self.x = self.x + self.velocity_x * dt
	self.y = self.y + self.velocity_y * dt
	return self:testPosition()
end

return Cloud
