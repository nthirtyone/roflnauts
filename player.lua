-- `Player`
-- Entity controlled by a player. It has a physical body and a sprite. Can play animations and interact with other instances of the same class.
-- Collision category: [2]

-- WHOLE CODE HAS FLAG OF "need a cleanup"
require "animated"

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
	-- HUD
	portrait_sprite = nil,
	portrait_frame  = nil,
	portrait_sheet  = require "nautsicons",
	portrait_box    = love.graphics.newQuad( 0, 15, 32,32, 80,130),
	-- Sounds
	sfx = require "sounds",
	-- Animations table
	animations = require "animations"
}
Player.__index = Player
setmetatable(Player, Animated)

-- Constructor of `Player`
function Player:new (game, world, x, y, name)
	-- Meta
	local o = {}
	setmetatable(o, self)
	-- Physics
	local group = -1-#game.Nauts
	o.body    = love.physics.newBody(world, x, y, "dynamic")
	o.shape   = love.physics.newRectangleShape(10, 16)
	o.fixture = love.physics.newFixture(o.body, o.shape, 8)
	o.fixture:setUserData(o)
	o.fixture:setCategory(2)
	o.fixture:setMask(2)
	o.fixture:setGroupIndex(group)
	o.body:setFixedRotation(true)
	-- Misc
	o.name   = name or "empty"
	o:setSprite(newImage("assets/nauts/"..o.name..".png"))
	o.world  = game
	o.punchcd = 0
	-- Animation
	o.current = o.animations.default
	o:createEffect("respawn")
	-- Portrait load for first object created
	if self.portrait_sprite == nil then
		self.portrait_sprite = love.graphics.newImage("assets/portraits.png")
		self.portrait_frame = love.graphics.newImage("assets/menu.png")
	end
	return o
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
	if self.salto and (self.current == self.animations.walk or self.current == self.animations.default) then
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

	Animated.update(self, dt)

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
function Player:controlpressed(set, action, key)
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
		self:setAnimation("default")
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
	-- pixel grid ; `approx` selected to prevent floating characters on certain conditions
	local approx = math.floor
	if (y - math.floor(y)) > 0.5 then approx = math.ceil end
	local draw_y = (approx(y) + offset_y) * scale
	local draw_x = (math.floor(x) + offset_x) * scale
	-- sprite draw
	Animated.draw(self, draw_x, draw_y, self.rotate, self.facing*scale, scale, 12, 15)
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
		for _,contact in pairs(self.body:getContactList()) do
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.setPointSize(scale)
			love.graphics.points(self.world.camera:translatePoints(contact:getPositions()))
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
-- default, walk, attack, attack_up, attack_down, damage
function Player:nextFrame()
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
-- direction: left, right, up, down
-- creates temporary fixture for player's body that acts as sensor; fixture is deleted after time set in UserData[1]; deleted by Player:update(dt)
function Player:hit(direction)
	-- start cooldown
	self.punchcd = Player.punchcd -- INITIAL from metatable
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
	fixture:setGroupIndex(self.fixture:getGroupIndex())
	fixture:setUserData({0.08, direction})
	-- sound
	self:playSound(4)
end

-- Taking damage of `Player` by successful hit test
-- currently called from World's startContact
function Player:damage(direction)
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
function Player:die()
	self:playSound(1)
	self.combo = Player.combo -- INITIAL from metatable
	self.lives = self.lives - 1
	self.alive = false
	self.spawntimer = Player.spawntimer -- INITIAL from metatable
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
	self:playSound(7)
end

-- Sounds
function Player:playSound(sfx, force)
	if self.alive or force then
		local source = love.audio.newSource(self.sfx[sfx])
		source:play()
	end
end
