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
	self.layers[1].ratio = 0

	self.map = map
	self:buildMap()
	self:initClouds()
	self:spawnNauts(nauts)

	self.camera = Camera(self.map.center.x, self.map.center.y, self)

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
			local x = image:getWidth() / -2
			local y = image:getHeight() / -2
			local bg = self:createDecoration(x, y, op.background) -- TODO: Decoration does not allow Image instead of filePath!
			bg.layer = self.layers[1]
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
	p.layer = self.layers[5]
	return p
end

function World:createNaut (x, y, name)
	local h = Player(name, x, y, self)
	table.insert(self.entities, h)
	h.layer = self.layers[4]
	return h
end

function World:createDecoration (x, y, sprite)
	local d = Decoration(x, y, self, sprite)
	table.insert(self.entities, d)
	d.layer = self.layers[3]
	return d
end

function World:createEffect (name, x, y)
	local e = Effect(name, x, y, self)
	table.insert(self.entities, e)
	e.layer = self.layers[5]
	return e
end

function World:createRay (naut)
	local r = Ray(naut, self)
	table.insert(self.entities, r)
	r.layer = self.layers[6]
	return r
end

-- TODO: Sprites' in general don't take actual Image in constructor. That is not only case of Decoration.
-- TODO: Once entities are stored inside single table create single `insertEntity` method for World.
function World:insertCloud (cloud)
	table.insert(self.entities, cloud)
	cloud.layer = self.layers[2]
	return cloud
end

--- Verbose wrapper for inserting entities into entities table.
-- @param entity entity to insert
function World:insertEntity (entity)
	if entity then
		table.insert(self.entities, entity)
		return entity
	end
end

--- Searches entities for those which return true with filtering function.
-- @param filter function with entity as parameter
-- @return table containing results of search
function World:getEntities (filter)
	local result = {}
	for _,entity in pairs(self.entities) do
		if filter(entity) then
			table.insert(result, entity)
		end
	end
	return result
end

--- Counts entities returning true with filtering function.
-- @param filter function with entity as parameter
-- @return entity count
function World:countEntities (filter)
	local count = 0
	for _,entity in pairs(self.entities) do
		if filter(entity) then
			count = count + 1
		end
	end
	return count
end

function World:getCloudsCount ()
	return self:countEntities(function (entity)
		return entity:is(Cloud)
	end)
end

function World:getNautsAll ()
	return self:getEntities(function (entity)
		return entity:is(require("not.Hero")) and not entity.body:isDestroyed()
	end)
end

function World:getNautsPlayable ()
	return self:getEntities(function (entity)
		return entity:is(require("not.Hero")) and entity.lives > -1
	end)
end

function World:getNautsAlive ()
	return self:getEntities(function (entity)
		return entity:is(require("not.Hero")) and entity.isAlive
	end)
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
	self.camera:sum(self.map.center.x, self.map.center.y)

	if self.cloudGenerator then
		self.cloudGenerator:update(dt)
	end

	for key,entity in pairs(self.entities) do
		if entity:update(dt) then
			table.remove(self.entities, key):delete()
		end
	end

	-- TODO: Weird Camera following Heroes.
	for _,hero in pairs(self:getNautsAll()) do
		self.camera:sum(hero:getPosition())
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
	for _,entity in pairs(self.entities) do
		if entity.draw and entity.layer then
			self.camera:translate(entity.layer.ratio)
			entity.layer:renderTo(entity.draw, entity, 0, 0, scale, debug)
			self.camera:pop()
		end
	end

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
	
	if debug then
		local center = self.map.center
		local ax, ay, bx, by = self.camera:getBoundariesScaled()

		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("rough")

		love.graphics.setColor(130,130,130)
		love.graphics.line(ax,center.y,bx,center.y)
		love.graphics.line(center.x,ay,center.x,by)

		love.graphics.setColor(200,200,200)
		love.graphics.line(ax,0,bx,0)
		love.graphics.line(0,ay,0,by)
	end
	self.camera:pop()

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
