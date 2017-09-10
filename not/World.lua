--- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.
-- TODO: Possibly move common parts of `World` and `Menu` to abstract class `Scene`.
World = require "not.Scene":extends()

require "not.Platform"
require "not.Player"
require "not.Effect"
require "not.Decoration"
require "not.Ray"
require "not.Cloud"
require "not.CloudGenerator"
require "not.Layer"

--- ZA WARUDO!
-- TODO: Missing documentation on most of World's methods.
function World:new (map, nauts)
	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(self:getContactCallbacks())

	self.lastNaut = false

	-- TODO: Clean layering. This is prototype. Seriously don't use it in production.
	self.entities = {}
	local width, height = love.graphics.getDimensions()
	self.layers = {
		Layer(width, height), -- back
		Layer(width, height), -- cloud
		Layer(width, height), -- deco
		Layer(width, height), -- nauts
		Layer(width, height), -- plats
		Layer(width, height), -- front
	}

	self.map = map
	self:buildMap()
	self:initClouds()
	self:spawnNauts(nauts)

	self.camera = Camera(self)

	musicPlayer:play(self.map.theme)
end

-- The end of the world
function World:delete ()
	for _,entity in pairs(self.entities) do
	 	entity:delete()
	end
	for _,layer in pairs(self.layers) do
		layer:delete()
	end
	self.world:destroy()
	collectgarbage()
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
			bg.layer = 1
		end
	end
end

function World:initClouds ()
	if self.map.clouds then
		self.cloudGenerator = CloudGenerator(self)
		self.cloudGenerator:run(6, true)
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
	local p = Platform(animations, polygon, x, y, self, sprite)
	table.insert(self.entities, p)
	return p
end

function World:createNaut (x, y, name)
	local naut = Player(name, x, y, self)
	table.insert(self.entities, naut)
	return naut
end

function World:createDecoration (x, y, sprite)
	local deco = Decoration(x, y, self, sprite)
	table.insert(self.entities, deco)
	return deco
end

function World:createEffect (name, x, y)
	local e = Effect(name, x, y, self)
	table.insert(self.entities, e)
	return e
end

function World:createRay (naut)
	local r = Ray(naut, self)
	table.insert(self.entities, r)
	return r
end

-- TODO: Sprites' in general don't take actual Image in constructor. That is not only case of Decoration.
-- TODO: Once entities are stored inside single table create single `insertEntity` method for World.
function World:insertCloud (cloud)
	table.insert(self.entities, cloud)
	return cloud
end

function World:getCloudsCount ()
	local count = 0
	for i,entity in ipairs(self.entities) do
		if entity:is(Cloud) then
			count = count + 1
		end
	end
	return count
end

function World:getNautsAll ()
	local nauts = {}
	for i,entity in ipairs(self.entities) do
		if entity:is(require("not.Hero")) then
			table.insert(nauts, entity)
		end
	end
	return nauts
end

function World:getNautsPlayable ()
	local nauts = {}
	for i,entity in ipairs(self.entities) do
		if entity:is(require("not.Hero")) then
			if entity.lives > -1 then
				table.insert(nauts, entity)
			end
		end
	end
	return nauts
end

function World:getNautsAlive ()
	local nauts = {}
	for i,entity in ipairs(self.entities) do
		if entity:is(require("not.Hero")) then
			if entity.isAlive then
				table.insert(nauts, entity)
			end
		end
	end
	return nauts
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

	for key,entity in pairs(self.entities) do
		if entity:update(dt) then
			table.remove(self.entities, key):delete()
		end
	end

	-- Some additional debug info.
	local stats = love.graphics.getStats()
	dbg_msg = string.format("%sMap: %s\nClouds: %d\nLoaded: %d\nMB: %.2f", dbg_msg, self.map.filename, self:getCloudsCount(), stats.images, stats.texturememory / 1024 / 1024)
end

function World:draw ()
	-- TODO: Offests are here to keep compatibility.
	local offset_x, offset_y = 0, 0
	local scale = getScale()
	local scaler = getRealScale()

	-- TODO: Prototype of layering. See `World@new`.
	-- TODO: Camera rewrite in progress.
	self.camera:translate()

	for _,entity in pairs(self.entities) do
		if entity:is(Decoration) then
			if entity.layer == 1 then
				self.layers[1]:setAsCanvas()
			else
				self.layers[3]:setAsCanvas()
			end
		end
		if entity:is(Cloud) then
			self.layers[2]:setAsCanvas()
		end
		if entity:is(Player) then
			self.layers[4]:setAsCanvas()
		end
		if entity:is(Platform) or entity:is(Effect) then
			self.layers[5]:setAsCanvas()
		end
		if entity:is(Ray) then
			self.layers[6]:setAsCanvas()
		end
		entity:draw(offset_x, offset_y, scale, debug)
	end

	self.camera:pop()
	love.graphics.setCanvas()

	for _,layer in ipairs(self.layers) do
		layer:draw()
		layer:clear()
	end

	-- TODO: Just move heroes' tags to front layer.
	self.camera:translate()
	for _,naut in pairs(self:getNautsAlive()) do
		naut:drawTag(offset_x, offset_y, scale)
	end	
	self.camera:pop()

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

	for _,naut in pairs(self:getNautsAll()) do
		-- I have no idea where to place them T_T
		-- let's do: bottom-left, bottom-right, top-left, top-right
		local w, h = love.graphics.getWidth()/scale, love.graphics.getHeight()/scale
		local y, e = 1, 1
		if _ < 3 then y, e = h-33, 0 end
		naut:drawHUD(1+(_%2)*(w-34), y, scale, e)
	end
end

--- Wraps World's beginContact and endContact to functions usable as callbacks for Box2D's world.
-- Only difference in new functions is absence of self as first argument.
-- @return wrapper for beginContact
-- @return wrapper for endContact
function World:getContactCallbacks ()
	local b = function (a, b, coll)
		self:beginContact(a, b, coll)
	end
	local e = function (a, b, coll)
		self:endContact(a, b, coll)
	end
	return b, e
end

-- TODO: Review current state of Box2D callbacks (again).
-- TODO: Stop using magical numbers in Box2D callbacks.
--	[1] -> Platform
--	[2] -> Hero
--	[3] -> Punch sensor
function World:beginContact (a, b, coll)
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
			self:createEffect("clash", x, y)
		end
	end
	if b:getCategory() == 3 then
		if a:getCategory() == 2 then
			a:getUserData():damage(b:getUserData()[2])
		end
	end
end
function World:endContact (a, b, coll)
	if a:getCategory() == 1 then
		b:getUserData().inAir = true
	end
end

-- Controller callbacks
function World:controlpressed (set, action, key)
	if key == "f6" and debug then
		local filename = self.map.filename
		local map = love.filesystem.load(filename)()
		map.filename = filename
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
