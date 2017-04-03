--- `Hero`
-- Hero (naut) entity that exists in a game world.
-- Collision category: [2]
Hero = {
	-- General and physics
	name = "empty",
	angle = 0,
	facing = 1,
	max_velocity = 105,
	world = --[[not.World]]nil,
	group = nil,
	-- Combat
	combo = 0,
	lives = 3,
	spawntimer = 2,
	alive = true,
	punchcd = 0.25,
	punchdir = 0, -- a really bad thing
	-- Movement
	inAir = true,
	salto = false,
	jumpactive = false,
	jumpdouble = true,
	jumptimer = 0.16,
	jumpnumber = 2,
	-- Keys
	controlset = nil,
	-- Statics
	portrait_sprite = nil,
	portrait_frame  = nil,
	portrait_sheet  = require "nautsicons",
	portrait_box    = love.graphics.newQuad( 0, 15, 32,32, 80,130),
	sfx = require "sounds",
}

-- `Hero` is a child of `PhysicalBody`.
require "not.PhysicalBody"
Hero.__index = Hero
setmetatable(Hero, PhysicalBody)

-- Constructor of `Hero`.
function Hero:new (game, world, x, y, name)
	local o = setmetatable({}, self)
	o:init(name, game, x, y)
	-- Load portraits statically.
	if self.portrait_sprite == nil then
		self.portrait_sprite = love.graphics.newImage("assets/portraits.png")
		self.portrait_frame = love.graphics.newImage("assets/menu.png")
	end
	return o
end

-- Initializator of `Hero`.
function Hero:init (name, world, x, y)
	-- Find imagePath based on hero name.
	local fileName = name or Hero.name -- INITIAL from metatable
	local imagePath = string.format("assets/nauts/%s.png", fileName)
	-- `PhysicalBody` initialization.
	PhysicalBody.init(self, world, x, y, imagePath)
	self:setBodyType("dynamic")
	self:setBodyFixedRotation(true)
	self.group = -1-#world.Nauts
	-- Main fixture initialization.
	local fixture = self:addFixture({-5,-8, 5,-8, 5,8, -5,8}, 8)
	fixture:setUserData(self)
	fixture:setCategory(2)
	fixture:setMask(2)
	fixture:setGroupIndex(self.group)
	-- Actual `Hero` initialization.
	self.world = world
	self.punchcd = 0
	self.name = name
	self:setAnimationsList(require("animations"))
	self:createEffect("respawn")
end

-- Control set managment
function Hero:assignControlSet (set)
	self.controlset = set
end
function Hero:getControlSet ()
	return self.controlset
end

-- Update callback of `Hero`
-- TODO: Explode this function (method, kek), move controler-related parts to `not.Player`, physics parts to `not.PhysicalBody`.
function Hero:update (dt)
	-- hotfix? for destroyed bodies
	if self.body:isDestroyed() then return end
	PhysicalBody.update(self, dt)
	-- locals
	local x, y = self.body:getLinearVelocity()
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	
	-- # VERTICAL MOVEMENT
	-- Jumping
	if self.jumpactive and self.jumptimer > 0 then
		self.body:setLinearVelocity(x,-160)
		self.jumptimer = self.jumptimer - dt
	end

	-- Salto
	if self.salto and (self.current == self.animations.walk or self.current == self.animations.default) then
		self.angle = (self.angle + 17 * dt * self.facing) % 360
	elseif self.angle ~= 0 then
		self.angle = 0
	end

	-- # HORIZONTAL MOVEMENT
	-- Walking
	if isDown(controlset, "left") then
		self.facing = -1
		self.body:applyForce(-250, 0)
		-- Controlled speed limit
		if x < -self.max_velocity then
			self.body:applyForce(250, 0)
		end
	end
	if isDown(controlset, "right") then
		self.facing = 1
		self.body:applyForce(250, 0)
		-- Controlled speed limit
		if x > self.max_velocity then
			self.body:applyForce(-250, 0)
		end
	end

	-- Custom linear damping
	if  not isDown(controlset, "left") and
		not isDown(controlset, "right")
	then
		local face = nil
		if x < -12 then
			face = 1
		elseif x > 12 then
			face = -1
		else
			face = 0
		end
		self.body:applyForce(40*face,0)
		if not self.inAir then
			self.body:applyForce(80*face,0)
		end
	end

	-- # DEATH
	-- We all die in the end.
	local m = self.world.map
	if (self.body:getX() < m.center_x - m.width*1.5 or self.body:getX() > m.center_x + m.width*1.5  or
	    self.body:getY() < m.center_y - m.height*1.5 or self.body:getY() > m.center_y + m.height*1.5) and
	    self.alive
	then
		self:die()
	end

	-- respawn
	if self.spawntimer > 0 then
		self.spawntimer = self.spawntimer - dt
	end
	if self.spawntimer <= 0 and not self.alive and self.lives >= 0 then
		self:respawn()
	end

	-- # PUNCH
	-- Cooldown
	self.punchcd = self.punchcd - dt
	if not self.body:isDestroyed() then -- This is weird
		for _,fixture in pairs(self.body:getFixtureList()) do
			if fixture:getUserData() ~= self then
				fixture:setUserData({fixture:getUserData()[1] - dt, fixture:getUserData()[2]})
				if fixture:getUserData()[1] < 0 then
					fixture:destroy()
				end
			end
		end
	end

	-- Stop vertical
	local c,a = self.current, self.animations
	if (c == a.attack_up or c == a.attack_down or c == a.attack) and self.frame < c.frames then
		if self.punchdir == 0 then
			self.body:setLinearVelocity(0,0)
		else
			self.body:setLinearVelocity(38*self.facing,0)
		end
	end

	if self.punchcd <= 0 and self.punchdir == 1 then
		self.punchdir = 0
	end
end

-- Controller callbacks
function Hero:controlpressed (set, action, key)
	if set ~= self:getControlSet() then return end
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	-- Jumping
	if action == "jump" then
		if self.jumpnumber > 0 then
			-- General jump logics
			self.jumpactive = true
			--self:playSound(6)
			-- Spawn proper effect
			if not self.inAir then
				self:createEffect("jump")
			else
				self:createEffect("doublejump")
			end
			-- Start salto if last jump
			if self.jumpnumber == 1 then
				self.salto = true
			end
			-- Animation clear
			if (self.current == self.animations.attack) or
			   (self.current == self.animations.attack_up) or
			   (self.current == self.animations.attack_down) then
				self:setAnimation("default")
			end
			-- Remove jump
			self.jumpnumber = self.jumpnumber - 1
		end
	end

	-- Walking
	if (action == "left" or action == "right") and 
	   (self.current ~= self.animations.attack) and
	   (self.current ~= self.animations.attack_up) and
	   (self.current ~= self.animations.attack_down) then
		self:setAnimation("walk")
	end

	-- Punching
	if action == "attack" and self.punchcd <= 0 then
		local f = self.facing
		self.salto = false
		if isDown(controlset, "up") then
			-- Punch up
			if self.current ~= self.animations.damage then
				self:setAnimation("attack_up")
			end
			self:hit("up")
		elseif isDown(controlset, "down") then
			-- Punch down
			if self.current ~= self.animations.damage then
				self:setAnimation("attack_down")
			end
			self:hit("down")
		else
			-- Punch horizontal
			if self.current ~= self.animations.damage then
				self:setAnimation("attack")
			end
			if f == 1 then
				self:hit("right")
			else
				self:hit("left")
			end
			self.punchdir = 1
		end
	end
end
function Hero:controlreleased (set, action, key)
	if set ~= self:getControlSet() then return end
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	-- Jumping
	if action == "jump" then
		self.jumpactive = false
		self.jumptimer = Hero.jumptimer -- take initial from metatable
	end
	-- Walking
	if (action == "left" or action == "right") and not
	   (isDown(controlset, "left") or isDown(controlset, "right")) and
	   self.current == self.animations.walk
	then
		self:setAnimation("default")
	end
end

-- TODO: comment them and place them somewhere properly
function Hero:getAngle ()
	return self.angle
end
function Hero:getHorizontalMirror()
	return self.facing
end
function Hero:getOffset ()
	return 12,15 -- TODO: WHY? How about creating body as polygon and using 0,0 instead. LIKE EVERYWHERE ELSE? Make it obsolete both in here and in `not.Sprite`.
end

-- Draw of `Hero`
-- TODO: see `not.PhysicalBody.draw` and `not.Sprite.draw`.
function Hero:draw (offset_x, offset_y, scale, debug)
	if not self.alive then return end
	PhysicalBody.draw(self, offset_x, offset_y, scale, debug)
end

-- Draw HUD of `Hero`
-- elevation: 1 bottom, 0 top
function Hero:drawHUD (x,y,scale,elevation)
	-- hud displays only if player is alive
	if self.alive then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.portrait_frame, self.portrait_box, (x)*scale, (y)*scale, 0, scale, scale)
		love.graphics.draw(self.portrait_sprite, self.portrait_sheet[self.name], (x+2)*scale, (y+3)*scale, 0, scale, scale)
		local dy = 30 * elevation
		love.graphics.setFont(Font)
		love.graphics.print((self.combo*10).."%",(x+2)*scale,(y-3+dy)*scale,0,scale,scale)
		love.graphics.print(math.max(0, self.lives),(x+24)*scale,(y-3+dy)*scale,0,scale,scale)
	end
end

-- Change animation of `Hero`
-- default, walk, attack, attack_up, attack_down, damage
function Hero:goToNextFrame ()
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	elseif isDown(controlset, "right") or isDown(controlset, "left") then
		-- If nonrepeatable animation is finished and player is walking
		self:setAnimation("walk")
	elseif self.current == self.animations.damage then
		self:setAnimation("default")
	end
end

-- Spawn `Effect` relative to `Hero`
function Hero:createEffect (name)
	if name == "trail" or name == "hit" then
		-- 16px effect: -7 -7
		self.world:createEffect(name, self.body:getX()-8, self.body:getY()-8)
	elseif name ~= nil then
		-- 24px effect: -12 -15
		self.world:createEffect(name, self.body:getX()-12, self.body:getY()-15)
	end
end

-- Punch of `Hero`
-- direction: left, right, up, down
-- creates temporary fixture for player's body that acts as sensor; fixture is deleted after time set in UserData[1]; deleted by Hero:update(dt)
function Hero:hit (direction)
	-- start cooldown
	self.punchcd = Hero.punchcd -- INITIAL from metatable
	-- actual punch
	local fixture
	if direction == "left" then
		fixture = love.physics.newFixture(self.body, love.physics.newPolygonShape(-2,-6, -20,-6, -20,6, -2,6), 0)
	end
	if direction == "right" then
		fixture = love.physics.newFixture(self.body, love.physics.newPolygonShape(2,-6, 20,-6, 20,6, 2,6), 0)
	end
	if direction == "up" then
		fixture = love.physics.newFixture(self.body, love.physics.newPolygonShape(-8,-4, -8,-20, 8,-20, 8,-4), 0)
	end
	if direction == "down" then
		fixture = love.physics.newFixture(self.body, love.physics.newPolygonShape(-8,4, -8,20, 8,20, 8,4), 0)
	end
	fixture:setSensor(true)
	fixture:setCategory(3)
	fixture:setMask(1,3)
	fixture:setGroupIndex(self.group)
	fixture:setUserData({0.08, direction})
	-- sound
	self:playSound(4)
end

-- Taking damage of `Hero` by successful hit test
-- currently called from World's startContact
function Hero:damage (direction)
	local horizontal, vertical = 0, 0
	if direction == "left" then
		horizontal = -1
	end
	if direction == "right" then
		horizontal = 1
	end
	if direction == "up" then
		vertical = -1
	end
	if direction == "down" then
		vertical = 1
	end
	self:createEffect("hit")
	local x,y = self.body:getLinearVelocity()
	self.body:setLinearVelocity(x,0)
	self.body:applyLinearImpulse((42+10*self.combo)*horizontal, (68+10*self.combo)*vertical + 15)
	self:setAnimation("damage")
	self.combo = math.min(27, self.combo + 1)
	self.punchcd = 0.08 + self.combo*0.006
	self:playSound(2)
end

-- DIE
function Hero:die ()
	self:playSound(1)
	self.combo = Hero.combo -- INITIAL from metatable
	self.lives = self.lives - 1
	self.alive = false
	self.spawntimer = Hero.spawntimer -- INITIAL from metatable
	self.body:setActive(false)
	self.world:onNautKilled(self)
end

-- And then respawn. Like Jon Snow.
function Hero:respawn ()
	self.alive = true
	self.body:setLinearVelocity(0,0)
	self.body:setPosition(self.world:getSpawnPosition())
	self.body:setActive(true)
	self:createEffect("respawn")
	self:playSound(7)
end

-- Sounds
function Hero:playSound (sfx, force)
	if self.alive or force then
		local source = love.audio.newSource(self.sfx[sfx])
		source:play()
	end
end
