Settings = {}

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
		for _,set in pairs(getSettings()) do
			local isJoystick = set[7]
			if isJoystick then
				-- Add first free joystick from joysticks list
			end
			Controller.registerSet(set[1], set[2], set[3], set[4], set[5], set[6], joystick)
		end
	end
end
