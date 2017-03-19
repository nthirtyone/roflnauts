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

-- Initializator of `PhysicalBody`.
function PhysicalBody:init (world, x, y, imagePath)
	Sprite.init(self, imagePath)
end

-- Update of `PhysicalBody`.
function PhysicalBody:update (dt)
	Sprite.update(self, dt)
end

-- Draw of `PhysicalBody`.
function PhysicalBody:draw (offset_x, offset_y, scale, debug)
	-- TODO: Move debug part here from `not.Hero.draw`.
end
