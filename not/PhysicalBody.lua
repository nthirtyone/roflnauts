--- `PhysicalBody`
-- Abstract class for drawable entity existing in `not.World`.
PhysicalBody = {
	body =--[[love.physics.newBody]]nil,
}

-- `PhysicalBody` is a child of `Sprite`.
require "not.Sprite"
PhysicalBody.__index = PhysicalBody
setmetatable(PhysicalBody, Sprite)

--[[ Constructor of `PhysicalBody`.
function PhysicalBody:new (world, x, y, imagePath)
	local o = setmetatable({}, self)
	o:init(world, x, y, imagePath)
	return o
end
]]

-- Initializer of `PhysicalBody`.
function PhysicalBody:init (world, x, y, imagePath)
	Sprite.init(self, imagePath)
	self.body = love.physics.newBody(world.world, x, y)
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

-- Various setters from Body.
-- type: BodyType ("static", "dynamic", "kinematic")
function PhysicalBody:setBodyType (type)
	self.body:setType(type)
end
function PhysicalBody:setBodyFixedRotation (bool)
	self.body:setFixedRotation(bool)
end

-- Update of `PhysicalBody`.
function PhysicalBody:update (dt)
	Sprite.update(self, dt)
	if self.body:isDestroyed() then return end
end

-- Draw of `PhysicalBody`.
function PhysicalBody:draw (offset_x, offset_y, scale, debug)
	Sprite.draw(self, offset_x, offset_y, scale)
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
			-- TODO: `world` is not a member of `PhysicalBody` or its instance normally.
			love.graphics.polygon("fill", self.world.camera:translatePoints(self.body:getWorldPoints(fixture:getShape():getPoints())))
		end
	end
end
