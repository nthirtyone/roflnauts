-- Default map from original roflnauts
return {
	center_x = 0,
	center_y = 30,
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
			x = 0,
			y = 0,
			shape = {-91,1, 90,1, 90,10, 5,76, -5,76, -91,10},
			sprite = "assets/platform_big.png"
		},
		{
			x = 140,
			y = 50,
			shape = {-26,1, 26,1, 26,30, -26,30},
			sprite = "assets/platform_small.png"
		},
		{
			x = -140,
			y = 50,
			shape = {-26,1, 26,1, 26,30, -26,30},
			sprite = "assets/platform_small.png"
		},
		{
			x = 0,
			y = -50,
			shape = {-17,1, 17,1, 17,16, -17,16},
			sprite = "assets/platform_top.png"
		}
	}
}