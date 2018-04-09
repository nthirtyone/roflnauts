--- `Hero`
-- Hero (often referred to as: "naut") entity that exists in a game world.
-- Collision category: [2]
Hero = require "not.PhysicalBody":extends()

-- Few are left...
Hero.sfx = require "config.sounds"

Hero.QUAD_FRAME = love.graphics.newQuad(0, 15, 32,32, 80,130)
Hero.IMAGE_PORTRAITS = nil
Hero.IMAGE_FRAME = nil
Hero.MAX_VELOCITY = 105
Hero.RESPAWN_TIME = 2
Hero.PUNCH_COOLDOWN = 0.25
Hero.PUNCH_FIXTURE_LIFETIME = 0.08
Hero.PUNCH_LEFT = {-2,-6, -20,-6, -20,6, -2,6}
Hero.PUNCH_RIGHT = {2,-6, 20,-6, 20,6, 2,6}
Hero.PUNCH_UP = {-8,-4, -8,-20, 8,-20, 8,-4}
Hero.PUNCH_DOWN = {-8,4, -8,20, 8,20, 8,4}
Hero.JUMP_TIMER = 0.16
Hero.JUMP_COUNT = 2

-- TODO: Portrait managment in Hero and config passed from Menu should be reviewed!
-- TODO: Clean-up, see `menus/select`.
function Hero:new (config, x, y, world)
	local imagePath = config.image
	Hero.load()
	Hero.__super.new(self, x, y, world, imagePath)
	-- Physics
	self.group = -1-#world:getNautsAll()
	self:setBodyType("dynamic")
	self:setBodyFixedRotation(true)
	self:newFixture()
	-- General
	self.config = config
	self.world = world
	self.angle = 0
	self.facing = 1
	-- Status
	self.combo = 0
	self.lives = 3
	self.inAir = true
	self.salto = false
	self.smoke = false
	self.isAlive = true
	self.spawntimer = 2
	self.jumpTimer = Hero.JUMP_TIMER
	self.jumpCounter = Hero.JUMP_COUNT
	self.punchCooldown = 0
	-- TODO: Pass loaded portrait from menu to Hero.
	self.portrait = love.graphics.newImage(config.portrait)
	self:setAnimations(require("config.animations.hero"))
	-- Post-creation
	self:createEffect("respawn")
end

-- TODO: This is temporarily called by constructor.
function Hero.load ()
	if Hero.IMAGE_PORTRAITS == nil then
		Hero.IMAGE_FRAME = love.graphics.newImage("assets/menu.png")
	end
end

--- Creates hero's fixture and adds it to physical body.
function Hero:newFixture ()
	local fixture = self:addFixture({-5,-8, 5,-8, 5,8, -5,8}, 8)
	fixture:setUserData(self)
	fixture:setCategory(2)
	fixture:setMask(2)
	fixture:setGroupIndex(self.group)
end

--- Called each game iteration.
-- @param dt time since last iteration
-- TODO: Cut this method into smaller parts.
function Hero:update (dt)
	Hero.__super.update(self, dt)

	if self.body:isDestroyed() then
		return
	end

	self:dampVelocity(dt)

	-- Salto
	if self.salto and (self.current == self.animations.walk or self.current == self.animations.default) then
		self.angle = (self.angle + 17 * dt * self.facing) % 360
	elseif self.angle ~= 0 then
		self.angle = 0
	end

	-- Death
	-- TODO: World/Map function for testing if Point is inside playable area.
	local m = self.world.map
	local x, y = self:getPosition()
	if (x < m.center.x - m.width*1.5 or x > m.center.x + m.width*1.5  or
	    y < m.center.y - m.height*1.5 or y > m.center.y + m.height*1.5) and
	    self.isAlive
	then
		self:die()
	end

	-- Respawn
	if self.spawntimer > 0 then
		self.spawntimer = self.spawntimer - dt
	end
	if self.spawntimer <= 0 and not self.isAlive and self.lives >= 0 then
		self:respawn()
	end

	-- Trail
	-- TODO: lower the frequency of spawning - currently it is each frame.
	if self.smoke and self.inAir then
		local dx, dy = love.math.random(-5, 5), love.math.random(-5, 5)
		self:createEffect("trail", dx, dy)
	end

	-- Punch cooldown
	self.punchCooldown = self.punchCooldown - dt
	if not self.body:isDestroyed() then -- TODO: This is weird
		for _,fixture in pairs(self.body:getFixtures()) do -- TODO: getFixtures from `PhysicalBody` or similar.
			if fixture:getUserData() ~= self then
				fixture:setUserData({fixture:getUserData()[1] - dt, fixture:getUserData()[2]})
				if fixture:getUserData()[1] < 0 then
					fixture:destroy()
				end
			end
		end
	end

	-- Walking
	-- TODO: Walking is still not satisfactiory. Think of way to improve it.
	if self:isWalking() then
		if not self._already_walking then
			self._already_walking = true
			self:onWalkingStarted()
		end
	else
		if self._already_walking then
			self._already_walking = false
			self:onWalkingStopped()
		end
	end
	if self:isWalkingLeft() then
		self:walk(-1)
	end
	if self:isWalkingRight() then
		self:walk(1)
	end

	-- Set predefined velocity when attack animations are playing
	local currentAnimation = self:getAnimation()
	if self.frame < currentAnimation.frames then
		if currentAnimation == self.animations.attack_up or currentAnimation == self.animations.attack_down then
			self:setLinearVelocity(0, 0)
		end
		if currentAnimation == self.animations.attack then
			self:setLinearVelocity(38*self.facing, 0)
		end
	end

	-- Jumping
	if self:isJumping() then
		if self.jumpTimer > 0 then
			if not self._jumping then
				self._jumping = true
				self:onJumpStarted()
			end
			if self.jumpCounter == 0 or self.jumpCounter == 1 then
				local x = self:getLinearVelocity()
				self:setLinearVelocity(x,-160)
				self.jumpTimer = self.jumpTimer - dt
			end
		end
	else
		if self._jumping then
			self._jumping = false
			self:onJumpStopped()
		end
	end
end

function Hero:walk (face)
	local x, y = self:getLinearVelocity()
	self.facing = face
	self:applyForce(250 * face, 0)
	if x > self.MAX_VELOCITY then
		self:applyForce(-250, 0)
	end
	if x < -self.MAX_VELOCITY then
		self:applyForce(250, 0)
	end
end

--- Damps linear velocity every frame by applying minor force to body.
function Hero:dampVelocity (dt)
	if not self:isWalking() then
		local face
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
end

--- Called each time Hero starts walking.
-- Is not called when direction of walking is changed.
function Hero:onWalkingStarted ()
	if (self.current ~= self.animations.attack) and
	   (self.current ~= self.animations.attack_up) and
	   (self.current ~= self.animations.attack_down) then
		self:setAnimation("walk")
	end
end

--- Called when Hero stops walking.
-- Is not called when direction of walking is changed.
function Hero:onWalkingStopped ()
	if not (self:isControlDown("left") or self:isControlDown("right")) then
		if self.current == self.animations.walk then
			self:setAnimation("default")
		end
	end
end

function Hero:onJumpStarted ()
	self.smoke = false

	if self.jumpCounter == 1 then
		self.salto = true
	end

	self.jumpCounter = self.jumpCounter - 1

	if self.jumpCounter > 0 then
		if not self.inAir then
			self:createEffect("jump")
		else
			self:createEffect("doublejump")
		end

		if (self.current == self.animations.attack) or
		   (self.current == self.animations.attack_up) or
		   (self.current == self.animations.attack_down) then
			self:setAnimation("default")
		end
	end
end

function Hero:onJumpStopped ()
	self.jumpTimer = Hero.JUMP_TIMER
end

function Hero:draw (debug)
	if not self.isAlive then return end
	Hero.__super.draw(self, debug)
	if debug then
		local x, y = self:getPosition()
		love.graphics.setColor(255, 50, 50)
		love.graphics.setFont(Font)
		local msg = string.format("%d %s %s", self.jumpCounter, tostring(self.jumpTimer > 0), tostring(self:isJumping()))
		love.graphics.print(msg, x + 10, y)
	end
end

-- TODO: Hero@drawTag's printf is not readable.
function Hero:drawTag ()
	local x,y = self:getPosition()
	love.graphics.setFont(Font)
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(string.format("Player %d", math.abs(self.group)), math.floor(x), math.floor(y)-26 ,100,'center',0,1,1,50,0)
end

-- Draw HUD of `Hero`
-- elevation: 1 bottom, 0 top
function Hero:drawHUD (x,y,scale,elevation)
	-- hud displays only if player is alive
	if self.isAlive then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.IMAGE_FRAME, self.QUAD_FRAME, (x)*scale, (y)*scale, 0, scale, scale)
		love.graphics.draw(self.portrait, (x+2)*scale, (y+3)*scale, 0, scale, scale)
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
	elseif self:isWalking() then
		self:setAnimation("walk")
	elseif self.current == self.animations.damage then
		self:setAnimation("default")
	end
end

-- Spawn `Effect` relative to `Hero`
function Hero:createEffect (name, dx, dy)
	local x, y = self.body:getX()-12, self.body:getY()-15
	if dx then
		x = x + dx
	end
	if dy then
		y = y + dy
	end
	self.world:createEffect(name, x, y)
end

-- Called by World when Hero starts contact with Platform (lands).
function Hero:land ()
	self.inAir = false
	self.jumpCounter = Hero.JUMP_COUNT
	self.salto = false
	self.smoke = false
	self:createEffect("land")
end

function Hero:getAngle ()
	return self.angle
end

function Hero:getHorizontalMirror ()
	return self.facing
end

function Hero:getOffset ()
	return 12,15
end

function Hero:isJumping ()
	return false
end

function Hero:isWalking ()
	return self:isWalkingLeft() or self:isWalkingRight()
end

function Hero:isWalkingLeft ()
	return false
end

function Hero:isWalkingRight ()
	return false
end

-- Creates temporary fixture for hero's body that acts as sensor.
-- direction:  ("left", "right", "up", "down")
-- Sensor fixture is deleted after time set in UserData[1]; deleted by `not.Hero.update`.
-- TODO: While it's good that punch animation changes are here, it is still bad. There is too much similar code in this method.
function Hero:punch (direction)
	self.punchCooldown = Hero.PUNCH_COOLDOWN
	self.salto = false
	self.smoke = false
	
	local shape
	if direction == "left" then
		shape = Hero.PUNCH_LEFT
		if self.current ~= self.animations.damage then
			self:setAnimation("attack")
		end
	end
	if direction == "right" then
		shape = Hero.PUNCH_RIGHT
		if self.current ~= self.animations.damage then
			self:setAnimation("attack")
		end
	end
	if direction == "up" then
		shape = Hero.PUNCH_UP
		if self.current ~= self.animations.damage then
			self:setAnimation("attack_up")
		end
	end
	if direction == "down" then
		shape = Hero.PUNCH_DOWN
		if self.current ~= self.animations.damage then
			self:setAnimation("attack_down")
		end
	end

	-- Create and set sensor fixture.
	local fixture = self:addFixture(shape, 0)
	fixture:setSensor(true)
	fixture:setCategory(3)
	fixture:setMask(1)
	fixture:setGroupIndex(self.group)
	fixture:setUserData({Hero.PUNCH_FIXTURE_LIFETIME, direction})
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
	if self.combo > 80 then
		self.smoke = true
	end
end

-- DIE
function Hero:die ()
	self:playSound(1)
	self.combo = 0
	self.lives = self.lives - 1
	self.isAlive = false
	self.spawntimer = Hero.RESPAWN_TIME
	self:setBodyActive(false)
	self.world:onNautKilled(self)
end

-- And then respawn. Like Jon Snow.
function Hero:respawn ()
	self.isAlive = true
	self.salto = false
	self.smoke = false
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

return Hero
