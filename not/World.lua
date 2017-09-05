--- `World`
-- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.
-- TODO: Possibly move common parts of `World` and `Menu` to abstract class `Scene`.
World = require "not.Scene":extends()

require "not.Platform"
require "not.Player"
require "not.Effect"
require "not.Decoration"
require "not.Ray"
require "not.CloudGenerator"

--- ZA WARUDO!
-- TODO: Missing documentation on most of World's methods.
function World:new (map, nauts)
	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(self.beginContact, self.endContact)

	-- TODO: Move all entities into single table.
	self.lastNaut = false
	self.Nauts = {}
	self.Platforms = {}
	self.Clouds = {}
	self.Effects = {}
	self.Decorations = {}
	self.Rays = {}

	self.map = map
	self:buildMap()
	self:initClouds()
	self:spawnNauts(nauts)

	self.camera = Camera:new(self)

	musicPlayer:setTrack(self.map.theme)
	musicPlayer:play()
end

-- The end of the world
function World:delete ()
	for _,platform in pairs(self.Platforms) do
	 	platform:delete()
	end
	for _,naut in pairs(self.Nauts) do
		naut:delete()
	end
	self.world:destroy()
end

--- Builds map using one of tables frin config files located in `config/maps/` directory.
function World:buildMap ()
	for _,op in pairs(self.map.create) do
		if op.platform then
			local path = string.format("config/platforms/%s.lua", op.platform)
			local config = love.filesystem.load(path)()
			self:createPlatform(op.x, op.y, config.shape, config.sprite, config.animations)
		end
		if op.decoration then
			self:createDecoration(op.x, op.y, op.decoration)
		end
		if op.background then
			local image = love.graphics.newImage(op.background)
			local bg = self:createDecoration(0, 0, op.background) -- TODO: Decoration does not allow Image instead of filePath!
			bg.ratio = op.ratio
		end
	end
end

-- TODO: Spawn some clouds after cloudGenerator has been initialized.
function World:initClouds ()
	if self.map.clouds then
		self.cloudGenerator = CloudGenerator(self)
	end
end

-- Spawn all the nauts for the round
function World:spawnNauts (nauts)
	for _,naut in pairs(nauts) do
		local x,y = self:getSpawnPosition()
		local spawn = self:createNaut(x, y, naut[1])
		spawn:assignControllerSet(naut[2])
	end
end

-- Get respawn location
function World:getSpawnPosition ()
	local n = love.math.random(1, #self.map.respawns)
	return self.map.respawns[n].x, self.map.respawns[n].y
end

-- TODO: Standardize `create*` methods with corresponding constructors. Pay attention to both params' order and names.
function World:createPlatform (x, y, polygon, sprite, animations)
	table.insert(self.Platforms, Platform(animations, polygon, x, y, self, sprite))
end

function World:createNaut (x, y, name)
	local naut = Player(name, x, y, self)
	table.insert(self.Nauts, naut)
	return naut
end

function World:createDecoration (x, y, sprite)
	local deco = Decoration(x, y, self, sprite)
	table.insert(self.Decorations, deco)
	return deco
end

function World:createEffect (name, x, y)
	table.insert(self.Effects, Effect(name, x, y, self))
end

function World:createRay (naut)
	table.insert(self.Rays, Ray(naut, self))
end

-- TODO: Sprites' in general don't take actual Image in constructor. That is not only case of Decoration.
-- TODO: Once entities are stored inside single table create single `insertEntity` method for World.
function World:insertCloud (cloud)
	table.insert(self.Clouds, cloud)
	return cloud
end

function World:getCloudsCount ()
	return #self.Clouds
end

-- get Nauts functions
-- more than -1 lives
function World:getNautsPlayable ()
	local nauts = {}
	for _,naut in pairs(self.Nauts) do
		if naut.lives > -1 then
			table.insert(nauts, naut)
		end
	end
	return nauts
end
-- are alive
function World:getNautsAlive ()
	local nauts = {}
	for _,naut in self.Nauts do
		if naut.isAlive then
			table.insert(nauts, naut)
		end
	end
	return nauts
end
-- all of them
function World:getNautsAll ()
	return self.Nauts
end

-- get Map name
function World:getMapName ()
	return self.map.name
end

-- Event: when player is killed
function World:onNautKilled (naut)
	self.camera:startShake()
	self:createRay(naut)
	local nauts = self:getNautsPlayable()
	if self.lastNaut then
		sceneManager:removeTopScene()
		sceneManager:changeScene(Menu())
	elseif #nauts < 2 then
		self.lastNaut = true
		naut:playSound(5, true)
		sceneManager:addScene(Menu("win"))
	end
end

-- LÖVE2D callbacks
-- Update ZU WARUDO
function World:update (dt)
	self.world:update(dt)
	self.camera:update(dt)

	if self.cloudGenerator then
		self.cloudGenerator:update(dt)
	end

	for _,naut in pairs(self.Nauts) do
		naut:update(dt)
	end
	for _,platform in pairs(self.Platforms) do
		platform:update(dt)
	end
	for _,decoration in pairs(self.Decorations) do
		decoration:update(dt)
	end
	for key,effect in pairs(self.Effects) do
		if effect:update(dt) then
			table.remove(self.Effects, key)
		end
	end
	for key,cloud in pairs(self.Clouds) do
		if cloud:update(dt) then
			table.remove(self.Clouds, key)
		end
	end
	for key,ray in pairs(self.Rays) do
		if ray:update(dt) then
			table.remove(self.Rays, key)
		end
	end
end

-- Draw
function World:draw ()
	-- Camera stuff
	local offset_x, offset_y = self.camera:getOffsets()
	local scale = getScale()
	local scaler = getRealScale()
	
	-- Background
	-- love.graphics.draw(self.background, 0, 0, 0, scaler, scaler)
	
	-- TODO: this needs to be reworked!
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

	-- Draw rays
	for _,ray in pairs(self.Rays) do
		ray:draw(offset_x, offset_y, scale)
	end

	-- draw center
	if debug then
		local c = self.camera
		local w, h = love.graphics.getWidth(), love.graphics.getHeight()
		-- draw map center
		love.graphics.setColor(130,130,130)
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("rough")
		local cx, cy = c:getPositionScaled()
		local x1, y1 = c:translatePosition(self.map.center.x, cy)
		local x2, y2 = c:translatePosition(self.map.center.x, cy+h)
		love.graphics.line(x1,y1,x2,y2)
		local x1, y1 = c:translatePosition(cx, self.map.center.y)
		local x2, y2 = c:translatePosition(cx+w, self.map.center.y)
		love.graphics.line(x1,y1,x2,y2)
		-- draw ox, oy
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

	for _,naut in pairs(self.Nauts) do
		naut:drawTag(offset_x, offset_y, scale)
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

-- Box2D callbacks
-- TODO: Review current state of Box2D callbacks.
-- TODO: Stop using magical numbers in Box2D callbacks.
--	[1] -> Platform
--	[2] -> Hero
--	[3] -> Punch sensor
function World.beginContact (a, b, coll)
	if a:getCategory() == 1 then
		local x,y = coll:getNormal()
		if y < -0.6 then
			b:getUserData():land()
		end
		local vx, vy = b:getUserData().body:getLinearVelocity()
		if math.abs(x) == 1 or (y < -0.6 and x == 0) then
			b:getUserData():playSound(3)
		end
	end
	if a:getCategory() == 3 then
		if b:getCategory() == 2 then
			b:getUserData():damage(a:getUserData()[2])
		end
		if b:getCategory() == 3 then
			a:getBody():getUserData():damage(b:getUserData()[2])
			b:getBody():getUserData():damage(a:getUserData()[2])
			local x1,y1 = b:getBody():getUserData():getPosition()
			local x2,y2 = a:getBody():getUserData():getPosition()
			local x = (x2 - x1) / 2 + x1 - 12
			local y = (y2 - y1) / 2 + y1 - 15
			a:getBody():getUserData().world:createEffect("clash", x, y)
		end
	end
	if b:getCategory() == 3 then
		if a:getCategory() == 2 then
			a:getUserData():damage(b:getUserData()[2])
		end
	end
end
function World.endContact (a, b, coll)
	if a:getCategory() == 1 then
		b:getUserData().inAir = true
	end
end

-- Controller callbacks
function World:controlpressed (set, action, key)
	if key == "f6" and debug then
		local map = love.filesystem.load(self.map.filepath)()
		map.filepath = self.map.filepath
		local nauts = {}
		for _,naut in pairs(self:getNautsAll()) do
			table.insert(nauts, {naut.name, naut:getControllerSet()})
		end
		local new = World(map, nauts)
		sceneManager:changeScene(new)
	end
	if key == "escape" then
		sceneManager:addScene(Menu("pause"))
		self:setInputDisabled(true)
		self:setSleeping(true)
	end
	for k,naut in pairs(self:getNautsAll()) do
		naut:controlpressed(set, action, key)
	end
end
function World:controlreleased (set, action, key)
	for k,naut in pairs(self:getNautsAll()) do
		naut:controlreleased(set, action, key)
	end
end
