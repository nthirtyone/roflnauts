return
{
	name = "Ribbit IV",
	theme = "ribbit.ogg",
	portrait = "assets/maps/ribbit.png",
	center = {x = 0, y = 50},
	width  = 360,
	height = 240,
	respawns = {
		{x = -15, y = -80},
		{x =  -5, y = -80},
		{x =   5, y = -80},
		{x =  15, y = -80}
	},
	create = {
		{
			ratio = 0,
			background = "assets/backgrounds/ribbit.png"
		},
		{
			x = -154,
			y = 10,
			platform = "ribbit-left"
		},
		{
			x = 67,
			y = 7,
			platform = "ribbit-right"
		},
		{
			x = -70,
			y = -5,
			platform = "ribbit-top"
		},
		{
			x = -54,
			y = 63,
			platform = "ribbit-bottom"
		}
	}
}
