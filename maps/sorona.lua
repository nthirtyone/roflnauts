-- Sorona, but with the worms and such.
return {
	-- GENERAL
	name = "sorona",
	theme = "sorona.ogg",
	center_x = 0,
	center_y = 0,
	width  = 360,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -98, y = -70},
		{x = 70, y = -70},
		{x = -30, y = -20},
		{x = -90, y = 40},
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/sorona.png",
	platforms = {
		{
			x = -60,
			y = 0,
			shape = {0,1, 59,1, 59,17, 0,17},
			sprite = "assets/platforms/sorona-center.png"
		},
		{
			x = -40,
			y = 55,
			shape = {3,0, 180,0, 180,20, 3,20},
			sprite = "assets/platforms/sorona-right-bottom.png"
		},
		{
			x = -120,
			y = 55,
			shape = {3,0, 62,0, 62,23, 3,23},
			sprite = "assets/platforms/sorona-left-bottom.png"
		},
		{
			x = 0,
			y = -50,
			shape = {1,1, 140,1, 1,17, 140,17},
			sprite = "assets/platforms/sorona-right-top.png"
		},
		{
			x = -150,
			y = -55,
			shape = {1,9, 106,9, 40,27, 1,27},
			sprite = "assets/platforms/sorona-left-top.png"
		}
	},
	decorations = {}
}
