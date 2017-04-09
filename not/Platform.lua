--- `Platform`
-- Static platform physical object with a sprite. `Players` can walk on it.
-- Collision category: [1]
-- TODO: reformat code to follow new code patterns
-- TODO: comment uncovered code parts
Platform = {
	world = --[[not.World]]nil,
}

-- `Platform` is a child of `PhysicalBody`.
require "not.PhysicalBody"
Platform.__index = Platform
setmetatable(Platform, PhysicalBody)

-- Constructor of `Platform`
function Platform:new (animations, shape, game, x, y, sprite)
	local o = setmetatable({}, self)
	o:init(animations, shape, game, x, y, sprite)
	return o
end

-- Initializer of `Platform`.
function Platform:init (animations, shape, world, x, y, imagePath)
	PhysicalBody.init(self, world, x, y, imagePath)
	self:setAnimationsList(animations)
	self.world = world
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