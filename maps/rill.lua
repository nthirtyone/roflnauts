return {
	-- CENTER AND SIZE
	name = "rill",
	center_x = 0,
	center_y = 60,
	width  = 320,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -100, y = 10},
		{x = -100, y = 10},
		{x =  100, y = 10},
		{x =  100, y = 10}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/rill.png",
	platforms = {
		{
			x = -120,
			y = 30,
			shape = {0,0, 40,0, 40,15, 0,15},
			sprite = "assets/platform_top.png"
		},
		{
			x = 80,
			y = 30,
			shape = {0,0, 40,0, 40,15, 0,15},
			sprite = "assets/platform_top.png"
		},
		{
			x = -15,
			y = 70,
			shape = {0,0, 30,0, 30,15, 0,15},
			sprite = "assets/platform_top.png"
		},
		{
			x = -110,
			y = 90,
			shape = {0,0, 10,-10, 90,80, 80,90},
			sprite = "assets/platform_top.png"
		},
		{
			x = 110,
			y = 90,
			shape = {0,0, -10,-10, -90,80, -80,90},
			sprite = "assets/platform_top.png"
		}
	},
	decorations = {}
}
