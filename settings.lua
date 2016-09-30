Settings = {}

function Settings.load()
	if Controller then
		Controller.registerSet("left", "right", "up", "down", "return", "rshift")
		Controller.registerSet("a", "d", "w", "s", "g", "h")
	end
end