-- Default map from original roflnauts
return {
	color_top = {193, 100,  99, 255},
	color_mid = {189,  95,  93, 255},
	color_bot = {179,  82,  80, 255},
	respawns = {
		{x = 130, y = 10},
		{x = 140, y = 10},
		{x = 150, y = 10},
		{x = 160, y = 10}
	},
	platforms = {
		{
			x = 145,
			y = 90,
			shape = {-91,1, 90,1, 90,10, 5,76, -5,76, -91,10},
			sprite = "assets/platform_big.png"
		},
		{
			x = 285,
			y = 140,
			shape = {-26,1, 26,1, 26,30, -26,30},
			sprite = "assets/platform_small.png"
		},
		{
			x = 5,
			y = 140,
			shape = {-26,1, 26,1, 26,30, -26,30},
			sprite = "assets/platform_small.png"
		},
		{
			x = 145,
			y = 40,
			shape = {-17,1, 17,1, 17,16, -17,16},
			sprite = "assets/platform_top.png"
		}
	}
}
