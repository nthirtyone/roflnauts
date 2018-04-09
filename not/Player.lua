--- `Player`
-- Right now this is more or less wrapper for Hero and various methods related to players' input.
-- TODO: Few more things should be exchanged between Player and Hero.
-- TODO: In the end this class could be implemented in form of more verbose and functional Controller class. Think about it.
Player = require "not.Hero":extends()

Player.controllerSet =--[[Controller.sets.*]]nil

--- Assigns controller set to Player.
-- @param set one of `Controller.sets`
function Player:assignControllerSet (set)
	self.controllerSet = set
end

function Player:getControllerSet ()
	return self.controllerSet
end

--- Wrapper for checking if passed control is currently pressed.
function Player:isControlDown (control)
	return Controller.isDown(self:getControllerSet(), control)
end

--- Overridden from Hero, used by Hero:update.
function Player:isJumping ()
	return self:isControlDown("jump")
end

--- Overridden from Hero, used by Hero:update.
function Player:isWalkingLeft ()
	return self:isControlDown("left")
end

--- Overridden from Hero, used by Hero:update.
function Player:isWalkingRight ()
	return self:isControlDown("right")
end

--- Called when control is pressed.
-- @param set ControllerSet that owns pressed control
-- @param action action assigned to control
-- @param key parent key of control
function Player:controlpressed (set, action, key)
	if set ~= self:getControllerSet() then return end
	self.smoke = false -- TODO: temporary

	if action == "attack" and self.punchCooldown <= 0 then
		local f = self.facing
		if self:isControlDown("up") then
			self:punch("up")
		elseif self:isControlDown("down") then
			self:punch("down")
		else
			if f == 1 then
				self:punch("right")
			else
				self:punch("left")
			end
		end
	end
end

--- Called when control is released.
function Player:controlreleased (set, action, key) end

return Player
