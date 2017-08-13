require "not.Sprite"

--- `Entity`
-- Basic, visible object to be used within World instance. Can be anything. Represented as `Sprite`.
-- We still need to keep old, global way of using modules but there are `returns` on the end at least.
-- It probably would be nice to move `World` dependency out of it but for now it should stay this way. Later `World` instance could be just passed to methods that need it.
Entity = Sprite:extends()

Entity.world =--[[not.World]]nil

-- Simple constructor for `Entity`.
function Entity:new (world, imagePath)
	Entity.__super.new(self, imagePath)
	self.world = world
end

return Entity
