return {
	-- CENTER AND SIZE
	name = "starstorm",
	theme = "starstorm.ogg",
	center_x = 0,
	center_y = -5,
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
				{0,1, 33,1, 39,6, 39,19, 31,21, 3,21},
				{40,6, 115,6, 114,14, 40,14}
			},
			sprite = "assets/platforms/starstorm-left-top.png"
		},
		{
			x = -156,
			y = -2,
			shape = {1,0, 109,0, 108,18, 1,20},
			sprite = "assets/platforms/starstorm-left-middle.png"
		},
		{
			x = -160,
			y = 69,
			shape = {0,4, 17,1, 97,1, 102,6, 102,11, 97,16, 19,16, 1,11},
			sprite = "assets/platforms/starstorm-left-bottom.png"
		},
		{
			x = 52,
			y = -55,
			shape = {
				{116,1, 83,1, 77,6, 77,19, 85,21, 113,21},
				{76,6, 1,6, 2,14, 76,14}
			},
			sprite = "assets/platforms/starstorm-right-top.png"
		},
		{
			x = 44,
			y = -2,
			shape = {109,0, 1,0, 2,18, 109,20},
			sprite = "assets/platforms/starstorm-right-middle.png"
		},
		{
			x = 55,
			y = 69,
			shape = {103,4, 86,1, 6,1, 1,6, 1,11, 6,16, 84,16, 102,11},
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
