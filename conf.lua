function love.conf (t)
	t.title = "Roflnauts 2"
	t.version = "0.10.2"
	t.window.width = 320
	t.window.height = 180
	t.identity = "not-nautz"
	t.console = false
	t.releases = {
		title = t.title,
		identifier = t.identity,
		package = "roflnauts",
		author = "The Roflnauts 2 Team",
		email = "nthirtyone@gmail.com",
		description = "Fan made sequel to Roflnauts.",
		homepage = "https://github.com/nthirtyone/roflnauts"
	}
end
