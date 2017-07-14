--- `World`
-- Used to manage physical world and everything inside it: clouds, platforms, nauts, background etc.
-- TODO: Possibly move common parts of `World` and `Menu` to abstract class `Scene`.
World = require "not.Scene":extends()

World.world =--[[love.physics.newWorld]]nil
World.Nauts =--[[{not.Hero}]]nil
World.Platforms =--[[{not.Platform}]]nil
World.Clouds =--[[{not.Cloud}]]nil
World.Decorations =--[[{not.Decoration}]]nil
World.Effects =--[[{not.Effect}]]nil
World.Rays =--[[{not.Ray}]]nil
World.camera =--[[not.Camera]]nil
World.music =--[[not.Music]]nil
World.clouds_delay = 5
World.map =--[[config.maps.*]]nil
World.background =--[[image?]]nil
World.lastNaut = false

require "not.Platform"
require "not.Player"
require "not.Cloud"
require "not.Effect"
require "not.Decoration"
require "not.Ray"

-- Constructor of `World` ZA WARUDO!
function World:new (map, nauts)
	-- Box2D physical world.
	love.physics.setMeter(64)
	self.world = love.physics.newWorld(0, 9.81*64, true)
	self.world:setCallbacks(self.beginContact, self.endContact)
	-- Tables for entities. TODO: It is still pretty bad!
	self.Nauts = {}
	self.Platforms = {}
	self.Clouds = {}
	self.Effects = {}
	self.Decorations = {}
	self.Rays = {}
	-- Map and misc.
	local map = map or "default"
	self:loadMap(map)
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

-- Load map from file
-- TODO: Change current map model to function-based one.
function World:loadMap (name)
	local name = name or "default"
	local map = love.filesystem.load(string.format("config/maps/%s.lua", name))
	self.map = map()
	-- Platforms
	for _,platform in pairs(self.map.platforms) do
		self:createPlatform(platform.x, platform.y, platform.shape, platform.sprite, platform.animations)
	end
	-- Decorations
	for _,decoration in pairs(self.map.decorations) do
		self:createDecoration(decoration.x, decoration.y, decoration.sprite)
	end
	-- Background
	self.background = love.graphics.newImage(self.map.background)
	-- Clouds
	if self.map.clouds then
		for i=1,6 do
			self:randomizeCloud(false)
		end
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

-- Add new platform to the world
-- TODO: it would be nice if function parameters would be same as `not.Platform.new`.
function World:createPlatform (x, y, polygon, sprite, animations)
	table.insert(self.Platforms, Platform(animations, polygon, x, y, self, sprite))
end

-- Add new naut to the world
-- TODO: separate two methods for `not.Hero` and `not.Player`.
function World:createNaut (x, y, name)
	local naut = Player(name, x, y, self)
	table.insert(self.Nauts, naut)
	return naut
end

-- Add new decoration to the world
-- TODO: `not.World.create*` functions often have different naming for parameters. It is not ground-breaking but it makes reading code harder for no good reason.
function World:createDecoration (x, y, sprite)
	table.insert(self.Decorations, Decoration(x, y, self, sprite))
end

-- Add new cloud to the world
-- TODO: extend variables names to provide better readability.
-- TODO: follow new parameters in `not.Cloud.new` based on `not.Cloud.init`.
function World:createCloud (x, y, t, v)
	table.insert(self.Clouds, Cloud(x, y, t, v, self))
end

-- Randomize Cloud creation
function World:randomizeCloud (outside)
	if outside == nil then
		outside = true
	else
		outside = outside
	end
	local x,y,t,v
	local m = self.map
	if outside then
		x = m.center_x-m.width*1.2+love.math.random(-50,20)
	else
		x = love.math.random(m.center_x-m.width/2,m.center_x+m.width/2)
	end
	y = love.math.random(m.center_y-m.height/2, m.center_y+m.height/2)
	t = love.math.random(1,3)
	v = love.math.random(8,18)
	self:createCloud(x, y, t, v)
end

-- Add an effect behind nauts
-- TODO: follow new parameters in `not.Effect.new` based on `not.Effect.init`.
-- TODO: along with `createRay` move this nearer reast of `create*` methods for readability.
function World:createEffect (name, x, y)
	table.insert(self.Effects, Effect(name, x, y, self))
end

-- Add a ray
function World:createRay (naut)
	table.insert(self.Rays, Ray(naut, self))
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
	-- Engine world: Nauts, Grounds (kek) and Decorations - all Animateds (top kek)
	for _,naut in pairs(self.Nauts) do
		naut:update(dt)
	end
	for _,platform in pairs(self.Platforms) do
		platform:update(dt)
	end
	for _,decoration in pairs(self.Decorations) do
		decoration:update(dt)
	end
	-- Clouds
	if self.map.clouds then
		-- generator
		local n = table.getn(self.Clouds)
		self.clouds_delay = self.clouds_delay - dt
		if self.clouds_delay < 0 and
		   n < 18
		then
			self:randomizeCloud()
			self.clouds_delay = self.clouds_delay + World.clouds_delay -- World.clouds_delay is initial
		end
		-- movement
		for _,cloud in pairs(self.Clouds) do
			if cloud:update(dt) > 340 then
				table.remove(self.Clouds, _)
			end
		end
	end
	-- Effects
	for _,effect in pairs(self.Effects) do
		if effect:update(dt) then
			table.remove(self.Effects, _)
		end
	end
	-- Rays
	for _,ray in pairs(self.Rays) do
		if ray:update(dt) then
			table.remove(self.Rays, _)
		end
	end
end
-- Draw
function World:draw ()
	-- Camera stuff
	local offset_x, offset_y = self.camera:getOffsets()
	local scale = self.camera.scale
	local scaler = self.camera.scaler
	
	-- Background
	love.graphics.draw(self.background, 0, 0, 0, scaler, scaler)
	
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
		local x1, y1 = c:translatePosition(self.map.center_x, cy)
		local x2, y2 = c:translatePosition(self.map.center_x, cy+h)
		love.graphics.line(x1,y1,x2,y2)
		local x1, y1 = c:translatePosition(cx, self.map.center_y)
		local x2, y2 = c:translatePosition(cx+w, self.map.center_y)
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
-- beginContact
function World.beginContact (a, b, coll)
	if a:getCategory() == 1 then
		local x,y = coll:getNormal()
		if y < -0.6 then
			-- TODO: move landing to `not.Hero`
			-- Move them to Hero
			b:getUserData().inAir = false
			b:getUserData().jumpCounter = 2
			b:getUserData().salto = false
			b:getUserData():createEffect("land")
		end
		local vx, vy = b:getUserData().body:getLinearVelocity()
		if math.abs(x) == 1 or (y < -0.6 and x == 0) then
			b:getUserData():playSound(3)
		end
	end
	if a:getCategory() == 3 then
		b:getUserData():damage(a:getUserData()[2])
	end
	if b:getCategory() == 3 then
		a:getUserData():damage(b:getUserData()[2])
	end
end
-- endContact
function World.endContact (a, b, coll)
	if a:getCategory() == 1 then
		-- Move them to Hero
		b:getUserData().inAir = true
	end
end

-- Controller callbacks
-- TODO: names of this methods don't follow naming patterns in this project. See `Controller` and change it.
function World:controlpressed (set, action, key)
	if key == "f6" and debug then
		local map = self:getMapName()
		local nauts = {}
		for _,naut in pairs(self:getNautsAll()) do
			table.insert(nauts, {naut.name, naut:getControllerSet()})
		end
		local new = World(map, nauts)
		sceneManager:changeScene(new)
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
