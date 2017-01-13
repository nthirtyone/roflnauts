return {
	-- GENERAL
	name = "ribbit",
	theme = "ribbit.mp3",
	center_x = 0,
	center_y = 50,
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
	clouds = false,
	background = "assets/backgrounds/ribbit.png",
	platforms = {
		{
			x = -154,
			y = 10,
			shape = {1,12, 48,12, 48,32, 1,32},
			sprite = "assets/platforms/ribbit-left.png"
		},
		{
			x = 67,
			y = 7,
			shape = {36,14, 83,14, 83,29, 36,29},
			sprite = "assets/platforms/ribbit-right.png"
		},
		{
			x = -70,
			y = -5,
			shape = {0,3, 140,3, 132,26, 8,26},
			sprite = "assets/platforms/ribbit-top.png"
		},
		{
			x = -54,
			y = 63,
			shape = {0,3, 108,3, 84,41, 24,41},
			sprite = "assets/platforms/ribbit-bottom.png"
		}
	},
	decorations = {}
}