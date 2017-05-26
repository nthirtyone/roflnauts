require "not.PhysicalBody"

--- `Hero`
-- Hero (often referred to as: "naut") entity that exists in a game world.
-- Collision category: [2]
Hero = PhysicalBody:extends()

Hero.name = "empty"
Hero.angle = 0
Hero.facing = 1
Hero.max_velocity = 105
Hero.group = nil
-- Combat
Hero.combo = 0
Hero.lives = 3
Hero.spawntimer = 2
Hero.isAlive = true
Hero.punchCooldown = 0.25
Hero.punchdir = 0 -- a really bad thing
-- Movement
Hero.inAir = true
Hero.salto = false
Hero.isJumping = false
Hero.isWalking = false
Hero.jumpTimer = 0.16
Hero.jumpCounter = 2
-- Statics
Hero.portrait_sprite = nil
Hero.portrait_frame = nil
Hero.portrait_sheet = getNautsIconsList()
Hero.portrait_box = love.graphics.newQuad(0, 15, 32,32, 80,130)
Hero.sfx = require "config.sounds"

-- Constructor of `Hero`.
function Hero:new (name, x, y, world)
	-- TODO: Statics moved temporarily here. Should be moved to e.g. `load()`.
	if Hero.portrait_sprite == nil then
		Hero.portrait_sprite = love.graphics.newImage("assets/portraits.png")
		Hero.portrait_frame = love.graphics.newImage("assets/menu.png")
	end
	-- Find imagePath based on hero name.
	local fileName = name or Hero.name -- INITIAL from prototype
	local imagePath = string.format("assets/nauts/%s.png", fileName)
	-- `PhysicalBody` initialization.
	Hero.__super.new(self, x, y, world, imagePath)
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
	self.punchCooldown = 0
	self.name = name
	self:setAnimationsList(require("config.animations.hero"))
	self:createEffect("respawn")
end

-- Update callback of `Hero`
function Hero:update (dt)
	Hero.__super.update(self, dt)
	if self.body:isDestroyed() then return end

	-- Salto
	if self.salto and (self.current == self.animations.walk or self.current == self.animations.default) then
		self.angle = (self.angle + 17 * dt * self.facing) % 360
	elseif self.angle ~= 0 then
		self.angle = 0
	end

	-- Custom linear damping.
	if not self.isWalking then
		local face = nil
		local x, y = self:getLinearVelocity()
		if x < -12 then
			face = 1
		elseif x > 12 then
			face = -1
		else
			face = 0
		end
		self:applyForce(40*face,0)
		if not self.inAir then
			self:applyForce(80*face,0)
		end
	end

	-- Could you please die?
	-- TODO: World/Map function for testing if Point is inside playable area.
	local m = self.world.map
	local x, y = self:getPosition()
	if (x < m.center_x - m.width*1.5 or x > m.center_x + m.width*1.5  or
	    y < m.center_y - m.height*1.5 or y > m.center_y + m.height*1.5) and
	    self.isAlive
	then
		self:die()
	end

	-- Respawn timer.
	if self.spawntimer > 0 then
		self.spawntimer = self.spawntimer - dt
	end
	if self.spawntimer <= 0 and not self.isAlive and self.lives >= 0 then
		self:respawn()
	end

	-- # PUNCH
	-- Cooldown
	self.punchCooldown = self.punchCooldown - dt
	if not self.body:isDestroyed() then -- TODO: This is weird
		for _,fixture in pairs(self.body:getFixtureList()) do -- TODO: getFixtures from `PhysicalBody` or similar.
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
			self:setLinearVelocity(0,0)
		else
			self:setLinearVelocity(38*self.facing,0)
		end
	end

	if self.punchCooldown <= 0 and self.punchdir == 1 then
		self.punchdir = 0
	end
end

-- TODO: comment them and place them somewhere properly
function Hero:getAngle ()
	return self.angle
end
function Hero:getHorizontalMirror ()
	return self.facing
end
function Hero:getOffset ()
	return 12,15
end

-- Draw of `Hero`
function Hero:draw (offset_x, offset_y, scale, debug)
	if not self.isAlive then return end
	Hero.__super.draw(self, offset_x, offset_y, scale, debug)
end

-- Draw HUD of `Hero`
-- elevation: 1 bottom, 0 top
function Hero:drawHUD (x,y,scale,elevation)
	-- hud displays only if player is alive
	if self.isAlive then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(self.portrait_frame, self.portrait_box, (x)*scale, (y)*scale, 0, scale, scale)
		love.graphics.draw(self.portrait_sprite, self.portrait_sheet[self.name], (x+2)*scale, (y+3)*scale, 0, scale, scale)
		local dy = 30 * elevation
		love.graphics.setFont(Font)
		love.graphics.print((self.combo).."%",(x+2)*scale,(y-3+dy)*scale,0,scale,scale)
		love.graphics.print(math.max(0, self.lives),(x+24)*scale,(y-3+dy)*scale,0,scale,scale)
	end
end

-- Change animation of `Hero`
-- default, walk, attack, attack_up, attack_down, damage
function Hero:goToNextFrame ()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	elseif self.isWalking then
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

-- Creates temporary fixture for hero's body that acts as sensor.
-- direction:  ("left", "right", "up", "down")
-- Sensor fixture is deleted after time set in UserData[1]; deleted by `not.Hero.update`.
-- TODO: Magic numbers present in `not.Hero.punch`.
function Hero:punch (direction)
	self.punchCooldown = Hero.punchCooldown -- INITIAL from prototype
	-- Choose shape based on punch direction.
	local shape
	if direction == "left" then shape = {-2,-6, -20,-6, -20,6, -2,6} end
	if direction == "right" then shape = {2,-6, 20,-6, 20,6, 2,6} end
	if direction == "up" then shape = {-8,-4, -8,-20, 8,-20, 8,-4} end
	if direction == "down" then shape = {-8,4, -8,20, 8,20, 8,4} end
	-- Create and set sensor fixture.
	local fixture = self:addFixture(shape, 0)
	fixture:setSensor(true)
	fixture:setCategory(3)
	fixture:setMask(1,3)
	fixture:setGroupIndex(self.group)
	fixture:setUserData({0.08, direction})
	self:playSound(4)
end

-- Taking damage of `Hero` by successful hit test
-- currently called from World's startContact
-- TODO: attack functions needs to be renamed, because even I have problems understanding them.
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
	local x,y = self:getLinearVelocity()
	self:setLinearVelocity(x,0)
	self:applyLinearImpulse((42+self.combo)*horizontal, (68+self.combo)*vertical + 15)
	self:setAnimation("damage")
	self.combo = math.min(999, self.combo + 10)
	self.punchCooldown = 0.08 + self.combo*0.0006
	self:playSound(2)
end

-- DIE
function Hero:die ()
	self:playSound(1)
	self.combo = Hero.combo -- INITIAL from prototype
	self.lives = self.lives - 1
	self.isAlive = false
	self.spawntimer = Hero.spawntimer -- INITIAL from prototype
	self:setBodyActive(false)
	self.world:onNautKilled(self)
end

-- And then respawn. Like Jon Snow.
function Hero:respawn ()
	self.isAlive = true
	self:setLinearVelocity(0,0)
	self:setPosition(self.world:getSpawnPosition()) -- TODO: I'm not convinced about getting new position like this.
	self:setBodyActive(true)
	self:createEffect("respawn")
	self:playSound(7)
end

-- Sounds
-- TODO: Possibly export to nonexistent SoundEmitter class. Can be used by World (Stage), too.
function Hero:playSound (sfx, force)
	if self.isAlive or force then
		local source = love.audio.newSource(self.sfx[sfx])
		source:play()
	end
end
