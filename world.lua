-- `World`
-- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "ground"
require "player"
require "cloud"
require "effect"
require "decoration"

-- Metatable of `World`
-- nils initialized in constructor
World = {
	-- inside
	world = nil,
	Nauts = nil,
	Platforms = nil,
	Clouds = nil,
	Decorations = nil,
	Effects = nil,
	camera = nil,
	-- cloud generator
	clouds_delay = 5,
	clouds_initial = nil,
	-- Map
	map = nil
}

-- Constructor of `World` ZA WARUDO!
function World:new(map, ...)
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
	local p     = {}
	o.Platforms = {}
	local c  = {}
	o.Clouds = c
	local e   = {}
	o.Effects = e
	local d = {}
	o.Decorations = d
	-- Random init
	math.randomseed(os.time())
	-- Map
	local map = map or "default"
	o:loadMap(map)
	-- Nauts
	o:spawnNauts(...)
	-- Create camera
	o.camera = Camera:new(o)
	-- Cloud generator
	o.clouds_initial = o.clouds_delay
	for i=1,6 do
		o:randomizeCloud(false)
	end
	return o
end

-- Load map from file
function World:loadMap(name)
	local name = name or "default"
	name = "maps/" .. name .. ".lua"
	local map = love.filesystem.load(name)
	self.map = map()
	for _,platform in pairs(self.map.platforms) do
		self:createPlatform(platform.x, platform.y, platform.shape, platform.sprite)
	end
	for _,decoration in pairs(self.map.decorations) do
		self:createDecoration(decoration.x, decoration.y, decoration.sprite)
	end
end

-- Spawn all the nauts for the round
function World:spawnNauts(...)
	local params = {...}
	local nauts = nil
	if type(params[1][1]) == "table" then
		nauts = params[1]
	else
		nauts = params
	end
	for _,naut in pairs(nauts) do
		local x,y = self:getSpawnPosition()
		local spawn = self:createNaut(x, y, naut[1])
		spawn:assignController(naut[2])
	end
end

-- Get respawn location
function World:getSpawnPosition()
	local n = math.random(1, #self.map.respawns)
	return self.map.respawns[n].x, self.map.respawns[n].y
end

-- Add new platform to the world
function World:createPlatform(x, y, polygon, sprite)
	table.insert(self.Platforms, Ground:new(self, self.world, x, y, polygon, sprite))
end

-- Add new naut to the world
function World:createNaut(x, y, name)
	local naut = Player:new(self, self.world, x, y, name)
	table.insert(self.Nauts, naut)
	return naut
end

-- Add new decoration to the world
function World:createDecoration(x, y, sprite)
	table.insert(self.Decorations, Decoration:new(x, y, sprite))
end

-- Add new cloud to the world
function World:createCloud(x, y, t, v)
	table.insert(self.Clouds, Cloud:new(x, y, t, v))
end

-- Randomize Cloud creation
function World:randomizeCloud(outside)
	if outside == nil then
		outside = true
	else
		outside = outside
	end
	local x,y,t,v
	local m = self.map
	if outside then
		x = m.center_x-m.width*1.2+math.random(-50,20)
	else
		x = math.random(m.center_x-m.width/2,m.center_x+m.width/2)
	end
	y = math.random(m.center_y-m.height/2, m.center_y+m.height/2)
	t = math.random(1,3)
	v = math.random(8,18)
	self:createCloud(x, y, t, v)
end

-- Add an effect behind nauts
function World:createEffect(name, x, y)
	table.insert(self.Effects, Effect:new(name, x, y))
end

-- Update ZU WARUDO
function World:update(dt)
	-- Physical world
	self.world:update(dt)
	-- Camera
	self.camera:update(dt)
	-- Nauts
	for _,naut in pairs(self.Nauts) do
		naut:update(dt)
	end
	-- Clouds
	-- generator
	local n = table.getn(self.Clouds)
	self.clouds_delay = self.clouds_delay - dt
	if self.clouds_delay < 0 and
	   n < 18
	then
		self:randomizeCloud()
		self.clouds_delay = self.clouds_delay + self.clouds_initial
	end
	-- movement
	for _,cloud in pairs(self.Clouds) do
		if cloud:update(dt) > 340 then
			table.remove(self.Clouds, _)
		end
	end
	-- Effects
	for _,effect in pairs(self.Effects) do
		if effect:update(dt) then
			table.remove(self.Effects, _)
		end
	end
end

-- Draw
function World:draw()
	-- Hard-coded background (for now)
	love.graphics.setColor(self.map.color_bot)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(self.map.color_mid)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()*0.8)
	love.graphics.setColor(self.map.color_top)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()*0.25)

	-- Camera stuff
	local offset_x, offset_y = self.camera:getOffsets()
	local scale = self.camera.scale

	-- Draw clouds
	for _,cloud in pairs(self.Clouds) do
		cloud:draw(offset_x, offset_y, scale)
	end

	-- Draw decorations
	for _,decoration in pairs(self.Decorations) do
		decoration:draw(offset_x, offset_y, scale)
	end

	-- Draw effects
	for _,effect in pairs(self.Effects) do
		effect:draw(offset_x,offset_y, scale)
	end

	-- Draw player
	for _,naut in pairs(self.Nauts) do
		naut:draw(offset_x, offset_y, scale, debug)
	end

	-- Draw ground
	for _,platform in pairs(self.Platforms) do
		platform:draw(offset_x, offset_y, scale, debug)
	end

	-- draw center
	if debug then
		local c = self.camera
		local w, h = love.graphics.getWidth(), love.graphics.getHeight()
		love.graphics.setColor(130,130,130)
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("rough")
		local cx, cy = c:getPositionScaled()
		local x1, y1 = c:translatePosition(self.map.center_x, cy)
		local x2, y2 = c:translatePosition(self.map.center_x, cy+h)
		love.graphics.line(x1,y1,x2,y2)
		local x1, y1 = c:translatePosition(cx, self.map.center_y)
		local x2, y2 = c:translatePosition(cx+w, self.map.center_y)
		love.graphics.line(x1,y1,x2,y2)
		love.graphics.setColor(200,200,200)
		love.graphics.setLineStyle("rough")
		local cx, cy = c:getPositionScaled()
		local x1, y1 = c:translatePosition(0, cy)
		local x2, y2 = c:translatePosition(0, cy+h)
		love.graphics.line(x1,y1,x2,y2)
		local x1, y1 = c:translatePosition(cx, 0)
		local x2, y2 = c:translatePosition(cx+w, 0)
		love.graphics.line(x1,y1,x2,y2)
	end

	-- Draw HUDs
	for _,naut in pairs(self.Nauts) do
		-- I have no idea where to place them T_T
		-- let's do: bottom-left, bottom-right, top-left, top-right
		local w, h = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale
		local y, e = 1, 1
		if _ < 3 then y, e = h-33, 0 end
		naut:drawHUD(1+(_%2)*(w-34), y, scale, e)
	end
end

-- beginContact
function World.beginContact(a, b, coll)
	if a:getCategory() == 1 then
		local x,y = coll:getNormal()
		if y == -1 then
			print(b:getUserData().name .. " is not in air")
			b:getUserData().inAir = false
			b:getUserData().jumpdouble = true
			b:getUserData().salto = false
			b:getUserData():createEffect("land")
		end
	end
end

-- endContact
function World.endContact(a, b, coll)
	if a:getCategory() == 1 then
		print(b:getUserData().name .. " is in air")
		b:getUserData().inAir = true
	end
end