return
{
	name = "ribbit",
	theme = "ribbit.ogg",
	portrait = 3, -- TODO: either separate portraits now or change `iconsList` and `menu/host`.
	center = {x = 0, y = 50},
	width  = 360,
	height = 240,
	respawns = {
		{x = -15, y = -80},
		{x =  -5, y = -80},
		{x =   5, y = -80},
		{x =  15, y = -80}
	},
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
			shape = {0,3, 139,3, 134,24, 5,24},
			sprite = "assets/platforms/ribbit-top.png"
		},
		{
			x = -54,
			y = 63,
			shape = {0,3, 107,3, 75,44, 32,44},
			sprite = "assets/platforms/ribbit-bottom.png"
		}
	},
	decorations = {}
}
