--- `Player`
-- Special `not.Hero` controllable by a player.
Player = {
	-- TODO: move functions and properties related to controls from `not.Hero`.
	controlSet = --[[Controller.sets.*]]nil,
}

-- `Player` is a child of `Hero`.
require "not.Hero"
Player.__index = Player
setmetatable(Player, Hero)

-- Constructor of `Player`.
function Player:new (name, game, x, y)
	local o = setmetatable({}, self)
	o:init(name, game, x, y)
	-- Load portraits statically to `not.Hero`.
	-- TODO: this is heresy, put it into `load` method or something similar.
	if Hero.portrait_sprite == nil then
		Hero.portrait_sprite = love.graphics.newImage("assets/portraits.png")
		Hero.portrait_frame = love.graphics.newImage("assets/menu.png")
	end
	return o
end

-- Initializer of `Player`.
function Player:init (...)
	Hero.init(self, ...)
end

-- Controller set manipulation.
function Player:assignControlSet (set)
	self.controlset = set
end
function Player:getControlSet ()
	return self.controlset
end

-- Check if control of assigned controller is pressed.
function Player:isControlDown (control)
	return Controller.isDown(self:getControlSet(), control)
end

-- Update of `Player`.
function Player:update (dt)
	local x, y = self:getLinearVelocity()
	Hero.update(self, dt) -- TODO: It would be probably a good idea to add return to update functions to terminate if something goes badly in parent's update.

	-- Jumping.
	if self.isJumping and self.jumpTimer > 0 then
		self:setLinearVelocity(x,-160)
		self.jumpTimer = self.jumpTimer - dt
	end

	-- Walking.
	if self:isControlDown("left") then
		self.facing = -1
		self:applyForce(-250, 0)
		-- Controlled speed limit
		if x < -self.max_velocity then
			self:applyForce(250, 0)
		end
	end
	if self:isControlDown("right") then
		self.facing = 1
		self:applyForce(250, 0)
		-- Controlled speed limit
		if x > self.max_velocity then
			self:applyForce(-250, 0)
		end
	end

	-- Limiting walking speed.
	if not self:isControlDown("left") and
	   not self:isControlDown("right")
	then
		local face = nil
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

-- Controller callbacks.
function Player:controlpressed (set, action, key)
	if set ~= self:getControlSet() then return end
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	-- Jumping
	if action == "jump" then
		if self.jumpCounter > 0 then
			-- General jump logics
			self.isJumping = true
			--self:playSound(6)
			-- Spawn proper effect
			if not self.inAir then
				self:createEffect("jump")
			else
				self:createEffect("doublejump")
			end
			-- Start salto if last jump
			if self.jumpCounter == 1 then
				self.salto = true
			end
			-- Animation clear
			if (self.current == self.animations.attack) or
			   (self.current == self.animations.attack_up) or
			   (self.current == self.animations.attack_down) then
				self:setAnimation("default")
			end
			-- Remove jump
			self.jumpCounter = self.jumpCounter - 1
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
	if action == "attack" and self.punchCooldown <= 0 then
		local f = self.facing
		self.salto = false
		if isDown(controlset, "up") then
			-- Punch up
			if self.current ~= self.animations.damage then
				self:setAnimation("attack_up")
			end
			self:punch("up")
		elseif isDown(controlset, "down") then
			-- Punch down
			if self.current ~= self.animations.damage then
				self:setAnimation("attack_down")
			end
			self:punch("down")
		else
			-- Punch horizontal
			if self.current ~= self.animations.damage then
				self:setAnimation("attack")
			end
			if f == 1 then
				self:punch("right")
			else
				self:punch("left")
			end
			self.punchdir = 1
		end
	end
end
function Player:controlreleased (set, action, key)
	if set ~= self:getControlSet() then return end
	local isDown = Controller.isDown
	local controlset = self:getControlSet()
	-- Jumping
	if action == "jump" then
		self.isJumping = false
		self.jumpTimer = Hero.jumpTimer -- take initial from metatable
	end
	-- Walking
	if (action == "left" or action == "right") and not
	   (isDown(controlset, "left") or isDown(controlset, "right")) and
	   self.current == self.animations.walk
	then
		self:setAnimation("default")
	end
end
