--- `PhysicalBody`
-- Abstract class for drawable body existing in Box2D's physical world.
PhysicalBody = {
	body =--[[love.physics.newBody]]nil,
}

-- `PhysicalBody` is a child of `Sprite`.
require "not.Sprite"
PhysicalBody.__index = PhysicalBody
setmetatable(PhysicalBody, Sprite)

-- Constructor of `PhysicalBody`.
function PhysicalBody:new (world, x, y, imagePath)
	local o = setmetatable({}, self)
	o:init(world, x, y, imagePath)
	return o
end

-- Initializator of `PhysicalBody`.
function PhysicalBody:init (world, x, y, imagePath)
	Sprite.init(self, imagePath)
end