-- `Player`
-- Collision category: [2]

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
function Player:new(world, x, y, spritesheet)
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
	o.body:setLinearDamping(0.1)
	-- Animation
	o.initial = o.delay
	o.current = o.animations.idle
	return o
end

-- Update callback of `Player`
function Player:update(dt)
	-- Jumping
	if self.jumpactive and self.jumptimer > 0 then
		local x,y = self.body:getLinearVelocity()
		self.body:setLinearVelocity(x,-160)
		self.jumptimer = self.jumptimer - dt
	end
	
	-- Walking
	if love.keyboard.isDown(self.key_left) then
		self.facing = -1
		local x,y = self.body:getLinearVelocity()
		if math.abs(x) > self.max_velocity then
			self.body:applyForce(-200, 0)
		else
			self.body:setLinearVelocity(-self.max_velocity/2, y)
		end
	end
	if love.keyboard.isDown(self.key_right) then
		self.facing = 1
		local x,y = self.body:getLinearVelocity()
		if math.abs(x) > self.max_velocity then
			self.body:applyForce(200, 0)
		else
			self.body:setLinearVelocity(self.max_velocity/2, y)
		end
	end
	
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
	
	-- Salto mothafocka
	if not self.jumpdouble and self.inAir then
		self.rotate = (self.rotate + 17 * dt * self.facing) % 360
	else
		self.rotate = 0
	end
	
	--[[
	-- Limit `Player` horizontal speed
	-- Maximum speed may be actually a little bit higher or lower
	local x,y = self.body:getLinearVelocity()
	if x > self.max_velocity then
		self.body:setLinearVelocity(self.max_velocity, y)
	end
	if x < -self.max_velocity then
		self.body:setLinearVelocity(-self.max_velocity, y)
	end
	--]]
end

-- Keypressed callback of `Player`
function Player:keypressed(key)
	-- Jumping
	if key == self.key_jump then
		if not self.inAir then
			self.jumpactive = true
		elseif self.jumpdouble then
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
function Player:keyreleased(key)
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

-- Change animation of `Player`
-- idle, walk, attack, attack_up, attack_down, damage
function Player:changeAnimation(animation)
	self.frame = 1
	self.delay = self.initial
	self.current = self.animations[animation]
end

-- Punch of `Player`
function Player:hit(horizontal, vertical)
	if vertical == -1 then
		self:changeAnimation("attack_up")
	elseif vertical == 1 then
		self:changeAnimation("attack_down")
	else
		self:changeAnimation("attack")
		self.body:applyForce(800*self.facing, 0)
	end
	for k,n in pairs(Nauts) do
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
function Player:damage(horizontal, vertical)
	self.body:applyLinearImpulse((10+10*self.combo)*horizontal, (50+10*self.combo)*vertical + 15)
	self:changeAnimation("damage")
end