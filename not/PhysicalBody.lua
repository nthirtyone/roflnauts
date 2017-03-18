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
	local o = Sprite:new(imagePath)
	return o
end