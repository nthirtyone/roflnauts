return {
	-- CENTER AND SIZE
	name = "rill",
	center_x = 0,
	center_y = 80,
	width  = 320,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -135, y = 10},
		{x = -135, y = 10},
		{x =  135, y = 10},
		{x =  135, y = 10}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/rill.png",
	platforms = {
		{
			x = -160,
			y = 25,
			shape = {2,2, 47,2, 47,18, 2,18},
			sprite = "assets/platforms/rill-block-left.png"
		},
		{
			x = 110,
			y = 25,
			shape = {0,2, 46,2, 42,18, 0,18},
			sprite = "assets/platforms/rill-block-right.png"
		},
		{
			x = -32,
			y = 70,
			shape = {2,2, 62,2, 42,18, 22,18},
			sprite = "assets/platforms/rill-center.png"
		},
		{
			x = -110,
			y = 90,
			shape = {2,2, 18,2, 76,41, 75,61, 2,9},
			sprite = "assets/platforms/rill-slide-left.png"
		},
		{
			x = 34,
			y = 90,
			shape = {2,44, 64,2, 75,2, 7,57},
			sprite = "assets/platforms/rill-slide-right.png"
		}
	},
	decorations = {}
}
