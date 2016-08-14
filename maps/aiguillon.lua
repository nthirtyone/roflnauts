return {
	-- CENTER AND SIZE
	name = "aiguillon",
	theme = "sorona.ogg",
	center_x = 0,
	center_y = -45,
	width  = 370,
	height = 290,
	-- RESPAWN POINTS
	respawns = {
		{x = -119, y = -28},
		{x = 115, y = -28},
		{x = 0, y = -90},
		{x = 0, y = 45},
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/aiguillon.png",
	platforms = {
		{
			x = -108,
			y = -72,
			shape = {1,0, 212,0, 212,12, 206,18, 14,18, 1,12},
			sprite = "assets/platforms/aiguillon-top.png"
		},
		{
			x = -46,
			y = 62,
			shape = {1,0, 87,0, 87,18, 14,18, 1,12},
			sprite = "assets/platforms/aiguillon-bottom.png"
		},
		{
			x = -144,
			y = -14,
			shape = {1,0, 50,0, 50,18, 5,18, 1,13},
			sprite = "assets/platforms/aiguillon-left-big.png"
		},
		{
			x = -82,
			y = 16,
			shape = {1,0, 25,0, 25,18, 1,18},
			sprite = "assets/platforms/aiguillon-left-small.png"
		},
		{
			x = 90,
			y = -14,
			shape = {1,0, 50,0, 50,12, 37,18, 1,18},
			sprite = "assets/platforms/aiguillon-right-big.png"
		},
		{
			x = 53,
			y = 16,
			shape = {1,0, 25,0, 25,18, 1,18},
			sprite = "assets/platforms/aiguillon-right-small.png"
		}
	},
	decorations = {}
}
