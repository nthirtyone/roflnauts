-- `Player`
-- Entity controlled by a player. It has a physical body and a sprite. Can play animations and interact with other instances of the same class.
-- Collision category: [2]

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `Player`
-- nils initialized in constructor
Player = {
	-- General and physics
	name = "empty",
	body = nil,
	shape = nil,
	fixture = nil,
	sprite = nil,
	rotate = 0, -- "angle" would sound better
	facing = 1,
	max_velocity = 105,
	world = nil, -- game world
	-- Combat
	combo = 0,
	lives = 3,
	spawntimer = 2,
	alive = true,
	punchcd = 0,
	punchinitial = 0.25,
	punchdir = 0, -- a really bad thing
	-- Animation
	animations = require "animations",
	current = nil,
	frame = 1,
	delay = 0.10,
	-- Movement
	inAir = true,
	salto = false,
	jumpactive = false,
	jumpdouble = true,
	jumptimer = 0.16,
	jumpnumber = 2,
	-- Keys
	controlset = nil,
	-- HUD
	portrait_sprite = nil,
	portrait_frame  = nil,
	portrait_sheet  = require "nautsicons",
	portrait_box    = love.graphics.newQuad( 0, 15, 32,32, 80,130),
	-- New punch mechanics
	hitbox_fixture,
	-- Sounds
	sfx = require "sounds"
}

-- Constructor of `Player`
function Player:new (game, world, x, y, name)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Physics
	o.body    = love.physics.newBody(world, x, y, "dynamic")
	o.shape   = love.physics.newRectangleShape(10, 16)
	o.fixture = love.physics.newFixture(o.body, o.shape, 8)
	o.fixture:setUserData(o)
	o.fixture:setCategory(2)
	o.fixture:setMask(2)
	o.body:setFixedRotation(true)
	-- Misc
	o.name   = name or "empty"
	o.sprite = newImage("assets/nauts/"..o.name..".png")
	o.world  = game
	-- Animation
	o.current = o.animations.idle
	o:createEffect("respawn")
	-- New punch mechanics
	o.hitbox_fixture = love.physics.newFixture(o.body, love.physics.newPolygonShape(0,-6,20,-6,20,6,0,6), 0)
	o.hitbox_fixture:setSensor(true)
	o.hitbox_fixture:setCategory(3)
	o.hitbox_fixture:setMask(1)
	local fixture = love.physics.newFixture(o.body, love.physics.newPolygonShape(0,-6,-20,-6,-20,6,0,6), 0)
	fixture:setSensor(true)
	fixture:setCategory(3)
	fixture:setMask(1)
	local fixture = love.physics.newFixture(o.body, love.physics.newPolygonShape(-8,0,-8,-20,8,-20,8,0), 0)
	fixture:setSensor(true)
	fixture:setCategory(3)
	fixture:setMask(1)
	local fixture = love.physics.newFixture(o.body, love.physics.newPolygonShape(-8,0,-8,20,8,20,8,0), 0)
	fixture:setSensor(true)
	fixture:setCategory(3)
	fixture:setMask(1)
	-- Portrait load for first object created
	if self.portrait_sprite == nil then
		self.portrait_sprite = love.graphics.newImage("assets/portraits.png")
		self.portrait_frame = love.graphics.newImage("assets/menu.png")
	end
	return o
end

-- Destructor of `Player`
function Player:delete()
	-- body deletion is handled by world deletion
	self.sprite = nil
end

-- Control set managment
function Player:assignControlSet(set)
	self.controlset = set
end
function Player:getControlSet()
	return self.controlset
end

-- Update callback of `Player`
function Player:update(dt)
	-- hotfix? for destroyed bodies
	if self.body:isDestroyed() then return end
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
	if self.salto and (self.current == self.animations.walk or self.current == self.animations.idle) then
		self.rotate = (self.rotate + 17 * dt * self.facing) % 360
	elseif self.rotate ~= 0 then
		self.rotate = 0
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

	-- # ANIMATIONS
	-- Animation
	self.delay = self.delay - dt
	if self.delay < 0 then
		self.delay = self.delay + Player.delay -- INITIAL from metatable
		-- Thank you De Morgan!
		if self.current.repeated or not (self.frame == self.current.frames) then
			self.frame = (self.frame % self.current.frames) + 1
		elseif isDown(controlset, "right") or isDown(controlset, "left") then
			-- If nonrepeatable animation is finished and player is walking
			self:changeAnimation("walk")
		elseif self.current == self.animations.damage then
			self:changeAnimation("idle")
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
function Player:controlpressed(set, action, key)
	if set ~= self:getControlSet() then return end
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	-- Jumping
	if action == "jump" then
		if self.jumpnumber > 0 then
			-- General jump logics
			self.jumpactive = true
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
				self:changeAnimation("idle")
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
		self:changeAnimation("walk")
	end

	-- Punching
	if action == "attack" and self.punchcd <= 0 then
		local f = self.facing
		self.salto = false
		if isDown(controlset, "up") then
			-- Punch up
			if self.current ~= self.animations.damage then
				self:changeAnimation("attack_up")
			end
			self:hit(-f,-18,4*f,10, 0, -1)
		elseif isDown(controlset, "down") then
			-- Punch down
			if self.current ~= self.animations.damage then
				self:changeAnimation("attack_down")
			end
			self:hit(-4,-2,4,9, 0, 1)
		else
			-- Punch horizontal
			if self.current ~= self.animations.damage then
				self:changeAnimation("attack")
			end
			self:hit(2*f,-4,8*f,4, f, 0)
			self.punchdir = 1
		end
	end
end
function Player:controlreleased(set, action, key)
	if set ~= self:getControlSet() then return end
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	-- Jumping
	if action == "jump" then
		self.jumpactive = false
		self.jumptimer = Player.jumptimer -- take initial from metatable
	end
	-- Walking
	if (action == "left" or action == "right") and not
	   (isDown(controlset, "left") or isDown(controlset, "right")) and
	   self.current == self.animations.walk
	then
		self:changeAnimation("idle")
	end
end

-- Draw of `Player`
function Player:draw(offset_x, offset_y, scale, debug)
	-- draw only alive
	if not self.alive then return end
	-- locals
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	local scale = scale or 1
	local debug = debug or false
	local x, y = self:getPosition()
	-- pixel grid
	local draw_x = (math.floor(x) + offset_x) * scale
	local draw_y = (math.floor(y) + offset_y) * scale
	-- sprite draw
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.sprite, self.current[self.frame], draw_x, draw_y, self.rotate, self.facing*scale, 1*scale, 12, 15)
	-- debug draw
	if debug then
		for _,fixture in pairs(self.body:getFixtureList()) do
			if fixture:getCategory() == 2 then
				love.graphics.setColor(137, 255, 0, 120)
			else
				love.graphics.setColor(137, 0, 255, 40)
			end
			love.graphics.polygon("fill", self.world.camera:translatePoints(self.body:getWorldPoints(fixture:getShape():getPoints())))
		end
	end
end

-- getPosition
function Player:getPosition()
	return self.body:getPosition()
end

-- Draw HUD of `Player`
-- elevation: 1 bottom, 0 top
function Player:drawHUD(x,y,scale,elevation)
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

-- Change animation of `Player`
-- idle, walk, attack, attack_up, attack_down, damage
function Player:changeAnimation(animation)
	self.frame = 1
	self.delay = Player.delay -- INITIAL from metatable
	self.current = self.animations[animation]
end

-- Spawn `Effect` relative to `Player`
function Player:createEffect(name)
	if name == "trail" or name == "hit" then
		-- 16px effect: -7 -7
		self.world:createEffect(name, self.body:getX()-8, self.body:getY()-8)
	elseif name ~= nil then
		-- 24px effect: -12 -15
		self.world:createEffect(name, self.body:getX()-12, self.body:getY()-15)
	end
end

-- Punch of `Player`
-- offset_x, offset_y, step_x, step_y, vector_x, vector_y
function Player:hit(ox, oy, sx, sy, vx, vy)
	-- start cooldown
	self.punchcd = self.punchinitial
	-- actual punch
	for k,n in pairs(self.world.Nauts) do
		if n ~= self then
			if self:testHit(n, ox, oy, sx, sy) then
				n:damage(vx, vy)
			end
		end
	end
	-- sound
	self:playSound(4)
end

-- Hittest
-- Should be replaced with actual sensor; after moving collision callbacks into Player
function Player:testHit(target, ox, oy, sx, sy)
	local x, y = self.body:getPosition()
	for v=0,2 do
		for h=0,2,1+v%2 do
			if target.fixture:testPoint(x+ox+h*sx, y+oy+v*sy) then return true end
		end
	end
	return false
end

-- Taking damage of `Player` by successful hit test
function Player:damage(horizontal, vertical)
	self:createEffect("hit")
	local x,y = self.body:getLinearVelocity()
	self.body:setLinearVelocity(x,0)
	self.body:applyLinearImpulse((42+10*self.combo)*horizontal, (68+10*self.combo)*vertical + 15)
	self:changeAnimation("damage")
	self.combo = math.min(27, self.combo + 1)
	self.punchcd = 0.08 + self.combo*0.006
	self:playSound(2)
end

-- DIE
function Player:die()
	self:playSound(1)
	self.combo = Player.combo
	self.lives = self.lives - 1
	self.alive = false
	self.spawntimer = Player.spawntimer
	self.body:setActive(false)
	self.world:onNautKilled(self)
end

-- And then respawn. Like Jon Snow.
function Player:respawn()
	self.alive = true
	self.body:setLinearVelocity(0,0)
	self.body:setPosition(self.world:getSpawnPosition())
	self.body:setActive(true)
	self:createEffect("respawn")
end

-- Sounds
function Player:playSound(sfx)
	if self.alive then
		local source = love.audio.newSource(self.sfx[sfx])
		source:play()
	end
end
