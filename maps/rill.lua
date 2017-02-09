return {
	-- CENTER AND SIZE
	name = "rill",
	theme = "rill.ogg",
	center_x = 0,
	center_y = 75,
	width  = 400,
	height = 260,
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
			x = -151,
			y = 25,
			shape = {0,0, 55,0, 55,11, 0,11},
			sprite = "assets/platforms/rill-flat-left.png"
		},
		{
			x = 93,
			y = 25,
			shape = {0,0, 55,0, 55,11, 0,11},
			sprite = "assets/platforms/rill-flat-right.png"
		},
		{
			x = -24,
			y = 55,
			shape = {0,0, 48,0, 47,15, 1,15},
			sprite = "assets/platforms/rill-center.png"
		},
		{
			x = -112,
			y = 80,
			shape = {77,30, 17,0, 0,0, 0,7, 77,44},
			sprite = "assets/platforms/rill-slope-left.png"
		},
		{
			x = 35,
			y = 80,
			shape = {0,30, 60,0, 77,0, 77,7, 0,44},
			sprite = "assets/platforms/rill-slope-right.png"
		}
	},
	decorations = {
		{
			x = 98,
			y = -20,
			sprite = "assets/decorations/rill-lollipop-big-purple.png"
		},
		{
			x = 127,
			y = 4,
			sprite = "assets/decorations/rill-lollipop-small-green.png"
		},
		{
			x = -152,
			y = -20,
			sprite = "assets/decorations/rill-lollipop-big-orange.png"
		},
		{
			x = -121,
			y = 4,
			sprite = "assets/decorations/rill-lollipop-small-blue.png"
		},
	}
}
