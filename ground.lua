-- `Ground`
-- Collision category: [1]

-- Metatable of `Ground`
-- nils initialized in constructor
Ground = {
	body = nil,
	shape = nil,
	fixture = nil,
	sprite = nil
}
-- Constructor of `Ground`
function Ground:new (world, x, y, shape, sprite)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.body    = love.physics.newBody(world, x, y)
	o.shape   = love.physics.newPolygonShape(shape)
	o.fixture = love.physics.newFixture(o.body, o.shape)
	o.sprite  = love.graphics.newImage(sprite)
	o.fixture:setCategory(1)
	o.fixture:setFriction(0.7)
	return o
end