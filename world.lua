-- `World`
-- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `World`
-- nils initialized in constructor
World = {
	world = nil,
	nauts = nil,
	platforms = nil,
	clouds = nil,
	camera = nil -- not sure yet? menu will need scaling too
}

-- Constructor of `World` ZA WARUDO!
function World:new()
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Physical world initialization
	love.physics.setMeter(64)
	o.world = love.physics.newWorld(0, 9.81*64, true)
	o.world:setCallbacks(o.beginContact, o.endContact)
	-- Empty tables for objects
	local c = {}
	o.clouds = c
	local n = {}
	o.nauts = n
	local p = {}
	o.platforms = {}
	return o
end

-- Add new platform to the world
function World:createPlatform(x, y, polygon, sprite)
	table.insert(self.platforms, Ground:new(self.world, x, y, polygon, sprite))
end

-- Add new naut to the world
function World:createNaut(x, y, sprite)
	table.insert(self.nauts, Player:new(self.world, x, y, sprite))
end

-- Add new cloud to the world

-- Update
-- Keypressed
-- Keyreleased
-- Draw

-- beginContact
-- endContact