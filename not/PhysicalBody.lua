require "not.Entity"

--- `PhysicalBody`
-- Abstract class for drawable entity existing in `not.World`.
PhysicalBody = Entity:extends()

PhysicalBody.body =--[[love.physics.newBody]]nil

-- Constructor of `PhysicalBody`.
-- `world` and `imagePath` are passed to parent's constructor (`Entity`).
function PhysicalBody:new (x, y, world, imagePath)
	PhysicalBody.__super.new(self, world, imagePath)
	self.body = love.physics.newBody(world.world, x, y)
	self.body:setUserData(self)
end

-- Add new fixture to body.
function PhysicalBody:addFixture (shape, density)
	local shape = love.physics.newPolygonShape(shape)
	local fixture = love.physics.newFixture(self.body, shape, density)
	return fixture
end

-- Position-related methods.
function PhysicalBody:getPosition ()
	return self.body:getPosition()
end
function PhysicalBody:setPosition (x, y)
	self.body:setPosition(x, y)
end

-- Velocity-related methods.
function PhysicalBody:setLinearVelocity (x, y)
	self.body:setLinearVelocity(x, y)
end
function PhysicalBody:getLinearVelocity ()
	return self.body:getLinearVelocity()
end

-- Various setters from Body.
-- type: BodyType ("static", "dynamic", "kinematic")
function PhysicalBody:setBodyType (type)
	self.body:setType(type)
end
function PhysicalBody:setBodyFixedRotation (bool)
	self.body:setFixedRotation(bool)
end
function PhysicalBody:setBodyActive (bool)
	self.body:setActive(bool)
end

-- Physical influence methods.
function PhysicalBody:applyLinearImpulse (x, y)
	self.body:applyLinearImpulse(x, y)
end
function PhysicalBody:applyForce (x, y)
	self.body:applyForce(x, y)
end

-- Update of `PhysicalBody`.
function PhysicalBody:update (dt)
	PhysicalBody.__super.update(self, dt)
end

-- Draw of `PhysicalBody`.
function PhysicalBody:draw (offset_x, offset_y, scale, debug)
	PhysicalBody.__super.draw(self, offset_x, offset_y, scale)
	if debug then
		for _,fixture in pairs(self.body:getFixtureList()) do
			local category = fixture:getCategory()
			if category == 1 then
				love.graphics.setColor(255, 69, 0, 140)
			end
			if category == 2 then
				love.graphics.setColor(137, 255, 0, 120)
			end
			if category == 3 then
				love.graphics.setColor(137, 0, 255, 40)
			end
			love.graphics.polygon("fill", self.world.camera:translatePoints(self.body:getWorldPoints(fixture:getShape():getPoints())))
		end
	end
end

return PhysicalBody
