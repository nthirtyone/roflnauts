-- `Controller`
-- Module to manage player input. 
-- It uses `love.keypressed`, `love.keyreleased`, `love.gamepadreleased`, `love.gamepadpressed`, `love.joystickadded`, so be sure not to use them by yourself.
-- Rather than that use functions provided by this module: `Controller.controlpressed` and `Controller.controlreleased`.
-- For information on additional functions, look below.

-- Namespace
Controller = {}
Controller.sets = {}
Controller.axes = {}
Controller.deadzone = .3

-- Declared to avoid calling nil. Be sure to define yours after this line is performed.
function Controller.controlpressed(set, action, key) end
function Controller.controlreleased(set, action, key) end

-- Create new controls set.
function Controller.registerSet(left, right, up, down, attack, jump, joystick)
	if not Controller.isJoystickUnique(joystick) then return end
	local set = {}
	set.left = left or "left"
	set.right = right or "right"
	set.up = up or "up"
	set.down = down or "down"
	set.attack = attack or "return"
	set.jump = jump or "rshift"
	set.joystick = joystick
	table.insert(Controller.sets, set)
	print(set, left, right, up, down, attack, jump, joystick)
	return set
end

-- Get table of controls sets.
function Controller.getSets()
	return Controller.sets
end

-- Checks if given joystick is unique in current set of Controller sets
function Controller.isJoystickUnique(joystick)
	if joystick ~= nil then
		for _,set in pairs(Controller.sets) do
			if set.joystick == joystick then return false end
		end
	end
	return true
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

-- Checks if given action of given set is down
function Controller.isDown(set, action)
	if set ~= nil then
		if set.joystick == nil then
			return love.keyboard.isDown(set[action])
		else
			if not Controller.isAxis(set[action]) then
				return set.joystick:isGamepadDown(set[action])
			else
				return Controller.getAxisState(set.joystick, set[action])
			end
		end
	end
end

-- Return key name from given axis and value
function Controller.createAxisName(axis, value)
	local key = "axis:"..axis
	if value == 0 then 
		key = key.."0"
	elseif value > 0 then
		key = key.."+" 
	else
		key = key.."-"
	end
	return key
end

-- Checks if given key is an axis
function Controller.isAxis(key)
	if string.find(key, "axis:") then
		return true
	else 
		return false 
	end
end

-- Checks state of key assigned to axis of given joystick
function Controller.getAxisState(joystick, key)
	if Controller.axes[joystick] then
		local state = Controller.axes[joystick][key]
		if state ~= nil then
			return state
		else
			return false
		end
	end
end

-- Sets state of key assigned to axis of given joystick
function Controller.setAxisState(joystick, key, state)
	if Controller.axes[joystick] == nil then
		Controller.axes[joystick] = {}
	end
	Controller.axes[joystick][key] = state
end

-- Simulate pressing key on an axis
function Controller.axisPress(joystick, axis, value)
	local key = Controller.createAxisName(axis, value)
	local set, action = Controller.testSets(key, joystick)
	local state = Controller.getAxisState(joystick, key)
	if not state then
		print(joystick, set, action, key)
		Controller.setAxisState(joystick, key, true)
		Controller.controlpressed(set, action, key)
	end
end

-- Simulate releasing key on an axis
function Controller.axisRelease(joystick, axis, value)
	local key = Controller.createAxisName(axis, value)
	local set, action = Controller.testSets(key, joystick)
	local state = Controller.getAxisState(joystick, key)
	if state then
		Controller.setAxisState(joystick, key,false)
		Controller.controlreleased(set, action, key)
	end
end

-- Callbacks from LÖVE2D
-- Load gamepad mappings from db file and init module
function Controller.load()
	love.joystick.loadGamepadMappings("gamecontrollerdb.txt")
end

-- Gamepad input callbacks
function Controller.gamepadaxis(joystick, axis, value)
	if value ~= 0 then
		if math.abs(value) > Controller.deadzone then
			Controller.axisPress(joystick, axis, value)
		else
			Controller.axisRelease(joystick, axis, value)
		end
	else
		Controller.axisRelease(joystick, axis, 1)
		Controller.axisRelease(joystick, axis, -1)
	end
end
function Controller.gamepadpressed(joystick, key)
	local set, action = Controller.testSets(key, joystick)
	print(joystick, set, action, key)
	Controller.controlpressed(set, action, key)
end
function Controller.gamepadreleased(joystick, key)
	local set, action = Controller.testSets(key, joystick)
	Controller.controlreleased(set, action, key)
end

-- Keyboard input callbacks
function Controller.keypressed(key)
	local set, action = Controller.testSets(key, nil)
	print(nil, set, action, key)
	Controller.controlpressed(set, action, key)
end
function Controller.keyreleased(key)
	local set, action = Controller.testSets(key, nil)
	Controller.controlreleased(set, action, key)
end