Settings = {}
Settings.current = {}
function Settings.load()
	if Controller then
		if not love.filesystem.exists("settings") then
			local def = love.filesystem.newFile("settings.default")
			local new = love.filesystem.newFile("settings")
			new:open("w") def:open("r")
			new:write(def:read())
			new:close() def:close()
		end
		local getSettings = love.filesystem.load("settings")
		Settings.current = getSettings()
		Controller.reset()
		local joysticksList = love.joystick.getJoysticks() -- local list for editing
		for _,set in pairs(Settings.current) do
			local isJoystick = set[7]
			local joystick
			if isJoystick then
				-- take and remove first joystick from list
				joystick = joysticksList[1]
				table.remove(joysticksList, 1)
			end
			if not isJoystick or joystick then
				Controller.registerSet(set[1], set[2], set[3], set[4], set[5], set[6], joystick)
			end
		end
	end
end
function Settings.save() 
	local new = love.filesystem.newFile("settings")
	local sets = Settings.current
	local string = "return {\n"
	for i,set in pairs(sets) do
		string = string .. "\t{"
		for j,word in pairs(set) do
			if j ~= 7 then
				string = string .. "\"" .. word .. "\", "
			else
				if word then
					string = string .. "true"
				else
					string = string .. "false"
				end
			end
		end
		string = string .. "},\n"
	end
	string = string .. "}"
	new:open("w")
	new:write(string)
	new:close()
end
function Settings.change(n, left, right, up, down, attack, jump, joystick)
	local bool
	if joystick then
		bool = true
	else
		bool = false
	end
	-- Save current settings
	Settings.current[n] = {left, right, up, down, attack, jump, bool}
	Settings.save()
	-- Load settings
	Settings.load()
end