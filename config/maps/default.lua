-- Default map from original roflnauts
return {
	-- GENERAL
	name = "default",
	theme = "default.ogg",
	center_x = 0,
	center_y = 0,
	width  = 360,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -15, y = -80},
		{x =  -5, y = -80},
		{x =   5, y = -80},
		{x =  15, y = -80}
	},
	-- GRAPHICS
	clouds = true,
	background = "assets/backgrounds/default.png",
	platforms = {
		{
			x = -91,
			y = 0,
			shape = {0,1, 180,1, 180,10, 95,76, 86,76, 0,10},
			sprite = "assets/platforms/default-big.png"
		},
		{
			x = 114,
			y = 50,
			shape = {0,1, 51,1, 51,18, 0,18},
			sprite = "assets/platforms/default-side.png"
		},
		{
			x = -166,
			y = 50,
			shape = {0,1, 51,1, 51,18, 0,18},
			sprite = "assets/platforms/default-side.png"
		},
		{
			x = -17,
			y = -50,
			shape = {0,1, 33,1, 33,14, 0,14},
			sprite = "assets/platforms/default-top.png"
		}
	},
	decorations = {}
}
