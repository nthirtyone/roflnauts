-- `Ground`
-- Static platform physical object with a sprite. `Players` can walk on it.
-- Collision category: [1]

-- WHOLE CODE HAS FLAG OF "need a cleanup"

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
	o.fixture:setFriction(0.2)
	return o
end

-- Draw of `Ground`
function Ground:draw (offset_x, offset_y, scale, debug)
	-- defaults
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	local debug = debug or false
	-- sprite draw
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.sprite, (self.body:getX()-math.ceil(self.sprite:getWidth()/2)+offset_x)*scale, (self.body:getY()+offset_y)*scale, 0, scale, scale)
	-- debug draw
	if debug then
		love.graphics.setColor(220, 220, 220, 100)
		love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
	end
end