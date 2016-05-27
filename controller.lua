-- `Controller`
-- Used to manage controls

-- Metashit
Controller = {
	joystick = nil,
	left = "left",
	right = "right",
	up = "up",
	down = "down",
	attack = "return", -- accept
	jump = "rshift", -- cancel
	parent = nil
}

-- Constructor
-- joystick, left, right, up, down, attack, jump
function Controller:new(joystick, ...)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	if joystick ~= nil then
		o.joystick = joystick
	end
	o:setBindings(...)
	return o
end

function Controller:setBindings(...)
	local left, right, up, down, attack, jump = ...
	self.left = left or "left"
	self.right = right or "right"
	self.up = up or "up"
	self.down = down or "down"
	self.attack = attack or "return"
	self.jump = jump or "rshift"
end

function Controller:setParent(parent)
	self.parent = parent or nil
end

function Controller:testControl(control)
	if control == self.left then
		return "left"
	elseif control == self.right then
		return "right"
	elseif control == self.up then
		return "up"
	elseif control == self.down then
		return "down"
	elseif control == self.attack then
		return "attack"
	elseif control == self.jump then
		return "jump"
	else
		return nil
	end
end

function Controller:keypressed(key, scancode)
	if self.parent ~= nil and self.joystick == nil then
		local control = self:testControl(key)
		if control ~= nil then
			self.parent:controllerPressed(control)
		end
	end
end

function Controller:keyreleased(key, scancode)
	if self.parent ~= nil and self.joystick == nil then
		local control = self:testControl(key)
		if control ~= nil then
			self.parent:controllerReleased(control)
		end
	end
end

function Controller:isDown(control)
	if self.joystick == nil then
		return love.keyboard.isDown(self[control])
	else
		return self.joystick:isGamepadDown(self[control])
	end
end