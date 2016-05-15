-- `World`
-- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `World`
-- nils initialized in constructor
World = {
	world = nil,
	Nauts = nil,
	Platforms = nil,
	Clouds = nil,
	camera = nil
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
	local n = {}
	o.Nauts = n
	local p = {}
	o.Platforms = {}
	local c = {}
	o.Clouds = c
	-- Create camera
	o.camera = Camera:new()
	return o
end

-- Add new platform to the world
function World:createPlatform(x, y, polygon, sprite)
	table.insert(self.Platforms, Ground:new(self.world, x, y, polygon, sprite))
end

-- Add new naut to the world
function World:createNaut(x, y, sprite)
	table.insert(self.Nauts, Player:new(self.world, x, y, sprite))
end

-- Add new cloud to the world
function World:createCloud(x, y, t)
	table.insert(self.Clouds, Cloud:new(x, y, t))
end

-- Update ZU WARUDO
function World:update(dt)
	-- Physical world
	self.world:update(dt)
	-- Camera
	self.camera:moveFollow()
	-- Nauts
	for _,naut in pairs(self.Nauts) do
		naut:update(dt)
	end
end

-- Keypressed
function World:keypressed(key)
	for _,naut in pairs(self.Nauts) do
		naut:keypressed(key)
	end
end

-- Keyreleased
function World:keyreleased(key)
	for _,naut in pairs(self.Nauts) do
		naut:keyreleased(key)
	end
end

-- Draw
function World:draw()
	-- Hard-coded background (for now)
	love.graphics.setColor(193, 100, 99, 255)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()*0.25)
	love.graphics.setColor(179, 82, 80, 255)
	love.graphics.rectangle("fill", 0, love.graphics.getHeight()*0.8, love.graphics.getWidth(), love.graphics.getHeight()*0.2)
	
	-- Camera stuff
	local offset_x, offset_y = self.camera:getOffsets()
	local scale = self.camera.scale
	
	-- Draw ground
	for _,platform in pairs(self.Platforms) do
		platform:draw(offset_x, offset_y, scale, debug)
	end
	
	-- Draw player
	for _,naut in pairs(self.Nauts) do
		naut:draw(offset_x, offset_y, scale, debug)
	end
end

-- beginContact
function World.beginContact(a, b, coll)
	local x,y = coll:getNormal()
	if y == -1 then
		print(b:getUserData().name .. " is not in air")
		b:getUserData().inAir = false
		b:getUserData().jumpdouble = true
	end
end

-- endContact
function World.endContact(a, b, coll)
	print(b:getUserData().name .. " is in air")
	b:getUserData().inAir = true
end