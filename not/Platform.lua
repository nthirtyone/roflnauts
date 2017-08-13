require "not.PhysicalBody"

--- `Platform`
-- Static platform physical object with a sprite. `Players` can walk on it.
-- Collision category: [1]
Platform = PhysicalBody:extends()

-- Constructor of `Platform`
function Platform:new (animations, shape, x, y, world, imagePath)
	Platform.__super.new(self, x, y, world, imagePath)
	self:setAnimationsList(animations)
	-- Create table of shapes if single shape is passed.
	if type(shape[1]) == "number" then
		shape = {shape}
	end
	-- Add all shapes from as fixtures to body.
	for _,single in pairs(shape) do
		local fixture = self:addFixture(single)
		fixture:setCategory(1)
		fixture:setFriction(0.2)
	end
end

return Platform
