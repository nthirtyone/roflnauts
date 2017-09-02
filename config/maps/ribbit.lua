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
			config = "ribbit-left"
		},
		{
			x = 67,
			y = 7,
			config = "ribbit-right"
		},
		{
			x = -70,
			y = -5,
			config = "ribbit-top"
		},
		{
			x = -54,
			y = 63,
			config = "ribbit-bottom"
		}
	},
	decorations = {}
}
