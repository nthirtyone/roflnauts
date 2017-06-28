require "not.Hero"

--- `Player`
-- Special `not.Hero` controllable by a player.
-- TODO: move functions and properties related to controls from `not.Hero`.
Player = Hero:extends()

Player.controllerSet =--[[Controller.sets.*]]nil

-- Constructor of `Player`.
function Player:new (name, x, y, world)
	Player.__super.new(self, name, x, y, world)
end

-- Controller set manipulation.
function Player:assignControllerSet (set)
	self.controllerSet = set
end
function Player:getControllerSet ()
	return self.controllerSet
end

-- Check if control of assigned controller is pressed.
function Player:isControlDown (control)
	return Controller.isDown(self:getControllerSet(), control)
end

-- Update of `Player`.
function Player:update (dt)
	Player.__super.update(self, dt) -- TODO: It would be probably a good idea to add return to update functions to terminate if something goes badly in parent's update.
	if self.body:isDestroyed() then return end
	local x, y = self:getLinearVelocity()
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
end

-- Controller callbacks.
function Player:controlpressed (set, action, key)
	if set ~= self:getControllerSet() then return end
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
	if (action == "left" or action == "right") then
		self.isWalking = true
		if (self.current ~= self.animations.attack) and
		   (self.current ~= self.animations.attack_up) and
		   (self.current ~= self.animations.attack_down) then
			self:setAnimation("walk")
		end
	end

	-- Punching
	if action == "attack" and self.punchCooldown <= 0 then
		local f = self.facing
		self.salto = false
		if self:isControlDown("up") then
			-- Punch up
			if self.current ~= self.animations.damage then
				self:setAnimation("attack_up")
			end
			self:punch("up")
		elseif self:isControlDown("down") then
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
	if set ~= self:getControllerSet() then return end
	-- Jumping
	if action == "jump" then
		self.isJumping = false
		self.jumpTimer = Hero.jumpTimer -- take initial from metatable
	end
	-- Walking
	if (action == "left" or action == "right") then
		if not (self:isControlDown("left") or self:isControlDown("right")) then
			self.isWalking = false
			if self.current == self.animations.walk then
				self:setAnimation("default")
			end
		end
	end
end

return Player
