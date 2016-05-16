-- `Player`
-- Entity controlled by a player. It has a physical body and a sprite. Can play animations and interact with other instances of the same class.
-- Collision category: [2]

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `Player`
-- nils initialized in constructor
Player = {
	-- General and physics
	name = "Player",
	body = nil,
	shape = nil,
	fixture = nil,
	sprite = nil,
	rotate = 0, -- "angle" would sound better
	facing = 1,
	max_velocity = 105,
	combo = 1,
	-- Animation
	animations = require "animations",
	current = nil,
	frame = 1,
	delay = 0.10,
	initial = nil,
	-- Movement
	inAir = true,
	jumpactive = false,
	jumpdouble = true,
	jumptimer = 0.14,
	-- Keys
	key_jump  = "rshift",
	key_left  = "left",
	key_right = "right",
	key_up    = "up",
	key_down  = "down",
	key_hit   = "return" -- don't ask
}

-- Constructor of `Player`
function Player:new (world, x, y, spritesheet)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Physics
	o.body    = love.physics.newBody(world, x, y, "dynamic")
	o.shape   = love.physics.newRectangleShape(10, 17)
	o.fixture = love.physics.newFixture(o.body, o.shape, 8)
	o.sprite  = love.graphics.newImage(spritesheet)
	o.fixture:setUserData(o)
	o.fixture:setCategory(2)
	o.fixture:setMask(2)
	o.body:setFixedRotation(true)
	-- Animation
	o.initial = o.delay
	o.current = o.animations.idle
	return o
end

-- Update callback of `Player`
function Player:update (dt)
	-- # VERTICAL MOVEMENT
	-- Jumping
	if self.jumpactive and self.jumptimer > 0 then
		local x,y = self.body:getLinearVelocity()
		self.body:setLinearVelocity(x,-160)
		self.jumptimer = self.jumptimer - dt
	end
	
	-- Salto
	if not self.jumpdouble and self.inAir and (self.current == self.animations.walk or self.current == self.animations.idle) then
		self.rotate = (self.rotate + 17 * dt * self.facing) % 360
	elseif self.rotate ~= 0 then
		self.rotate = 0
	end
	
	-- # HORIZONTAL MOVEMENT
	-- Walking
	local x,y = self.body:getLinearVelocity()
	if love.keyboard.isDown(self.key_left) then
		self.facing = -1
		self.body:applyForce(-200, 0)
		-- Controlled speed limit
		if x < -self.max_velocity then
			self.body:applyForce(200, 0)
		end
	end
	if love.keyboard.isDown(self.key_right) then
		self.facing = 1
		self.body:applyForce(200, 0)
		-- Controlled speed limit
		if x > self.max_velocity then
			self.body:applyForce(-200, 0)
		end
	end
	
	-- Custom linear damping
	if  not self.inAir and
		not love.keyboard.isDown(self.key_left) and
		not love.keyboard.isDown(self.key_right)
	then
		local face = nil
		if x < -12 then
			face = 1
		elseif x > 12 then
			face = -1
		else
			face = 0
		end
		self.body:applyForce(120*face,0)
	end
	
	-- # ANIMATIONS
	-- Animation
	self.delay = self.delay - dt
	if self.delay < 0 then
		self.delay = self.delay + self.initial
		-- Thank you De Morgan!
		if self.current.repeated or not (self.frame == self.current.frames) then
			self.frame = (self.frame % self.current.frames) + 1
		elseif love.keyboard.isDown(self.key_right) or
			   love.keyboard.isDown(self.key_left)
		then
			-- If nonrepeatable animation is finished and player is walking
			self:changeAnimation("walk")
		elseif self.current == self.animations.damage then
			self:changeAnimation("idle")
		end
	end
end

-- Keypressed callback of `Player`
function Player:keypressed (key)
	-- Jumping
	if key == self.key_jump then
		if not self.inAir then
			w:createEffectBottom("jump", self.body:getX()-12, self.body:getY()-15)
			self.jumpactive = true
			if (self.current == self.animations.attack) or 
			   (self.current == self.animations.attack_up) or
			   (self.current == self.animations.attack_down) then
				self:changeAnimation("idle")
			end
		elseif self.jumpdouble then
			w:createEffectBottom("doublejump", self.body:getX()-12, self.body:getY()-15)
			self.jumpactive = true
			self.jumpdouble = false
		end
	end
	
	-- Walking
	if key == self.key_left or key == self.key_right then
		self:changeAnimation("walk")
	end
	
	-- Punching
	if key == self.key_hit then
		-- Punch up
		if love.keyboard.isDown(self.key_up) then
			self:hit(0, -1)
		-- Punch down
		elseif love.keyboard.isDown(self.key_down) and self.inAir then
			self:hit(0, 1)
		-- Punch horizontal
		else
			self:hit(self.facing, 0)
		end
	end
end

-- Keyreleased callback of `Player`
function Player:keyreleased (key)
	-- Jumping
	if key == self.key_jump then
		self.jumpactive = false
		self.jumptimer = 0.12
	end
	
	-- Walking
	if (key == self.key_left or key == self.key_right) and not
	   (love.keyboard.isDown(self.key_left) or love.keyboard.isDown(self.key_right)) and
	   self.current == self.animations.walk
	then
		self:changeAnimation("idle")
	end
end

-- Draw of `Player`
function Player:draw (offset_x, offset_y, scale, debug)
	-- defaults
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	local scale = scale or 1
	local debug = debug or false
	-- sprite draw
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.sprite, self.current[self.frame], (self.body:getX()+offset_x)*scale, (self.body:getY()+offset_y)*scale, self.rotate, self.facing*scale, 1*scale, 12, 15)
	-- debug draw
	if debug then
		love.graphics.setColor(50, 255, 50, 100)
		love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
		love.graphics.setColor(255,255,255,255)
		love.graphics.points(self.body:getX()+12*self.facing,self.body:getY()-2)
		love.graphics.points(self.body:getX()+ 6*self.facing,self.body:getY()+2)
		love.graphics.points(self.body:getX()+18*self.facing,self.body:getY()+2)
		love.graphics.points(self.body:getX()+12*self.facing,self.body:getY()+6)
	end
end

-- Change animation of `Player`
-- idle, walk, attack, attack_up, attack_down, damage
function Player:changeAnimation(animation)
	self.frame = 1
	self.delay = self.initial
	self.current = self.animations[animation]
end

-- Punch of `Player`
-- REWORK NEEDED Issue #8
function Player:hit (horizontal, vertical)
	if vertical == -1 then
		self:changeAnimation("attack_up")
	elseif vertical == 1 then
		self:changeAnimation("attack_down")
	else
		self:changeAnimation("attack")
		self.body:applyLinearImpulse(10*self.facing, 0)
	end
	-- w.Nauts [!] temporary
	for k,n in pairs(w.Nauts) do
		if n ~= self then
			local didHit = false
			if n.fixture:testPoint(self.body:getX()+12*horizontal,self.body:getY()-2) then
				didHit = true
			end
			if n.fixture:testPoint(self.body:getX()+7*horizontal,self.body:getY()+2) then
				didHit = true
			end
			if n.fixture:testPoint(self.body:getX()+17*horizontal,self.body:getY()+2) then
				didHit = true
			end
			if n.fixture:testPoint(self.body:getX()+12*horizontal,self.body:getY()+6) then
				didHit = true
			end
			if didHit then
				n:damage(horizontal, vertical)
				n.combo = n.combo + 1
				print(n.combo)
			end
		end
	end
end

-- Taking damage of `Player` by successful hit test
function Player:damage (horizontal, vertical)
	self.body:applyLinearImpulse((34+12*self.combo)*horizontal, (50+10*self.combo)*vertical + 15)
	self:changeAnimation("damage")
end