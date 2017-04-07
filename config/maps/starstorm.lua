return {
	-- CENTER AND SIZE
	name = "starstorm",
	theme = "starstorm.ogg",
	center_x = 0,
	center_y = -20,
	width  = 400,
	height = 260,
	-- RESPAWN POINTS
	respawns = {
		{x = 100, y = 45},
		{x = -100, y = 45},
		{x = -90, y = -25},
		{x = 90, y = -25},
		{x = -110, y = -70},
		{x = 110, y = -70}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/starstorm.png",
	platforms = {
		{
			x = -170,
			y = -55,
			shape = {
				{0,1, 33,1, 39,6, 39,21, 31,21, 0,21},
				{40,6, 115,6, 115,14, 40,14}
			},
			sprite = "assets/platforms/starstorm-left-top.png"
		},
		{
			x = -156,
			y = -2,
			shape = {0,0, 109,0, 109,20, 0,20},
			sprite = "assets/platforms/starstorm-left-middle.png"
		},
		{
			x = -160,
			y = 69,
			shape = {0,4, 8,4, 13,1, 102,1, 102,16, 19,16, 0,11},
			sprite = "assets/platforms/starstorm-left-bottom.png"
		},
		{
			x = 52,
			y = -55,
			shape = {
				{115,1, 82,1, 76,6, 76,21, 84,21, 115,21},
				{75,6, 0,6, 0,14, 75,14}
			},
			sprite = "assets/platforms/starstorm-right-top.png"
		},
		{
			x = 44,
			y = -2,
			shape = {109,0, 0,0, 0,20, 109,20},
			sprite = "assets/platforms/starstorm-right-middle.png"
		},
		{
			x = 55,
			y = 69,
			shape = {102,4, 94,4, 89,1, 0,1, 0,16, 83,16, 102,11},
			sprite = "assets/platforms/starstorm-right-bottom.png"
		},
		{
			x = -27,
			y = 40,
			shape = {0,6, 53,6, 53,14, 0,14},
			sprite = "assets/platforms/starstorm-center.png"
		}
	},
	decorations = {
		{
			x = -166,
			y = -37,
			sprite = "assets/decorations/starstorm-left-top.png"
		},
		{
			x = -163,
			y = 19,
			sprite = "assets/decorations/starstorm-left-bottom.png"
		},
		{
			x = 119,
			y = -37,
			sprite = "assets/decorations/starstorm-right-top.png"
		},
		{
			x = 52+77,
			y = 19,
			sprite = "assets/decorations/starstorm-right-bottom.png"
		}
	}
}
