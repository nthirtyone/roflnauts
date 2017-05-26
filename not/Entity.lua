require "not.Sprite"

--- `Entity`
-- Basic, visible object to be used within World instance. Can be anything. Represented as `Sprite`.
-- We still need to keep old, global way of using modules but there are `returns` on the end at least.
Entity = Sprite:extends()

Entity.world =--[[not.World]]nil

-- Simple constructor for `Entity`.
function Entity:new (world, imagePath)
	Entity.__super.new(self, imagePath)
	self.world = world
end

return Entity
