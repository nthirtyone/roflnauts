-- Default map from original roflnauts
return {
	center_x = 0,
	center_y = 0,
	width  = 320,
	height = 240,
	color_top = {193, 100,  99, 255},
	color_mid = {189,  95,  93, 255},
	color_bot = {179,  82,  80, 255},
	respawns = {
		{x = -15, y = -80},
		{x =  -5, y = -80},
		{x =   5, y = -80},
		{x =  15, y = -80}
	},
	platforms = {
		{
			x = -91,
			y = 0,
			shape = {0,1, 181,1, 181,10, 96,76, 86,76, 0,10},
			sprite = "assets/platform_big.png"
		},
		{
			x = 114,
			y = 50,
			shape = {0,1, 52,1, 52,30, 0,30},
			sprite = "assets/platform_small.png"
		},
		{
			x = -166,
			y = 50,
			shape = {0,1, 52,1, 52,30, 0,30},
			sprite = "assets/platform_small.png"
		},
		{
			x = -17,
			y = -50,
			shape = {0,1, 34,1, 34,16, 0,16},
			sprite = "assets/platform_top.png"
		}
	}
}