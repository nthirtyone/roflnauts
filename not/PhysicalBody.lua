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

function PhysicalBody:draw (debug)
	PhysicalBody.__super.draw(self, debug)
	if debug then
		for _,fixture in pairs(self.body:getFixtures()) do
			local category = fixture:getCategory()
			-- TODO: Fixture drawing of PhysicalBodies could take activity into account in every case.
			if category == 1 then
				love.graphics.setColor(1, .3, 0, .6)
			end
			if category == 2 then
				love.graphics.setColor(.5, 1, 0, .6)
			end
			if category == 3 then
				love.graphics.setColor(.5, 0, 1, .2)
			end
			if category == 4 then
				if self.body:isActive() then
					love.graphics.setColor(1, .9, 0, .2)
				else
					love.graphics.setColor(1, .9, 0, .04)
				end
			end
			local camera = self.world.camera
			love.graphics.polygon("fill", self.body:getWorldPoints(fixture:getShape():getPoints()))
		end
	end
end

return PhysicalBody
