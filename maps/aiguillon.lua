return {
	-- CENTER AND SIZE
	name = "aiguillon",
	theme = "aiguillon.mp3",
	center_x = 0,
	center_y = 10,
	width  = 370,
	height = 290,
	-- RESPAWN POINTS
	respawns = {
		{x = 0, y = -80},
		{x = 0, y = -80},
		{x = 0, y = -80},
		{x = 0, y = -80},
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/aiguillon.png",
	platforms = {
		{
			x = -108,
			y = 22,
			shape = {1,0, 212,0, 212,12, 206,18, 14,18, 1,12},
			sprite = "assets/platforms/aiguillon-wide.png"
		},
		{
			x = -46,
			y = -19,
			shape = {1,0, 87,0, 87,18, 14,18, 1,12},
			sprite = "assets/platforms/aiguillon-middle.png"
		},
		{
			x = -141,
			y = -57,
			shape = {1,0, 50,0, 50,18, 5,18, 1,13},
			sprite = "assets/platforms/aiguillon-left-big.png"
		},
		{
			x = -132,
			y = 84,
			shape = {1,0, 25,0, 25,18, 1,18},
			sprite = "assets/platforms/aiguillon-left-small.png"
		},
		{
			x = 77,
			y = -57,
			shape = {1,0, 50,0, 50,12, 37,18, 1,18},
			sprite = "assets/platforms/aiguillon-right-big.png"
		},
		{
			x = 103,
			y = 84,
			shape = {1,0, 25,0, 25,18, 1,18},
			sprite = "assets/platforms/aiguillon-right-small.png"
		}
	},
	decorations = {}
}
