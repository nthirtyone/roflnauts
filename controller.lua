-- `Controller`
-- Module to manage player input. 
-- It uses `love.keypressed`, `love.keyreleased`, `love.gamepadreleased`, `love.gamepadpressed`, `love.joystickadded`, so be sure not to use them by yourself.
-- Rather than that use functions provided by this module: `Controller.controlpressed` and `Controller.controlreleased`.
-- For information on additional functions, look below.

-- Namespace
Controller = {}
Controller.sets = {}

-- Declared to avoid calling nil. Be sure to define yours after this line is performed.
function Controller.controlpressed(set, action, key) end
function Controller.controlreleased(set, action, key) end

-- Create new controls set.
function Controller.registerSet(left, right, up, down, attack, jump, joystick)
	local set = {}
	set.left = left or "left"
	set.right = right or "right"
	set.up = up or "up"
	set.down = down or "down"
	set.attack = attack or "return"
	set.jump = jump or "rshift"
	table.insert(Controller.sets, set)
	print(set, left, right, up, down, attack, jump, joystick)
	return set
end

-- Tests all sets if they have control assigned to given key and joystick.
function Controller.testSets(key, joystick)
	for i,set in pairs(Controller.sets) do
		local action = Controller.testControl(set, key, joystick)
		if action ~= nil then
			return set, action
		end
	end
	return nil, nil
end

-- Tests given set if it has controll assigned to given key and joystick.
function Controller.testControl(set, key, joystick)
	-- First test if it is joystick and if it is correct one
	if joystick == set.joystick then
		if key == set.left then
			return "left"
		elseif key == set.right then
			return "right"
		elseif key == set.up then
			return "up"
		elseif key == set.down then
			return "down"
		elseif key == set.attack then
			return "attack"
		elseif key == set.jump then
			return "jump"
		end
	end
end
--love.keyboard.isDown(set[action])
--set.joystick:isGamepadDown(set[action])
-- Checks if given action of given set is down
function Controller.isDown(set, action)
	if set ~= nil then
		if set.joystick == nil then
			return love.keyboard.isDown(set[action])
		end
	end
end

-- Callbacks from LÖVE2D
-- Create new sets when new joystick is added
function Controller.joystickadded(joystick)
	Controller.registerSet("dpleft", "dpright", "dpup", "dpdown", "a", "b", joystick)
end

-- Gamepad input callbacks
function Controller.gamepadpressed(joystick, key)
	local set, action = Controller.testSets(key, joystick)
	print("Pressed:", set, action, key)
	Controller.controlpressed(set, action, key)
end
function Controller.gamepadreleased(joystick, key)
	local set, action = Controller.testSets(key, joystick)
	print("Released:", set, action, key)
	Controller.controlreleased(set, action, key)
end

-- Keyboard input callbacks
function Controller.keypressed(key)
	local set, action = Controller.testSets(key, nil)
	print("Pressed:", set, action, key)
	Controller.controlpressed(set, action, key)
end
function Controller.keyreleased(key)
	local set, action = Controller.testSets(key, nil)
	print("Released:", set, action, key)
	Controller.controlreleased(set, action, key)
end