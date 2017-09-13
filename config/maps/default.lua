return
{
	name = "default",
	theme = "default.ogg",
	portrait = 1, -- TODO: See `maps/ribbit`.
	center = {x = 0, y = 0},
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
			clouds = "assets/clouds.png",
			animations = "clouds-default",
			count = 4,
			ratio = 0.9
		},
		{
			clouds = "assets/clouds.png",
			animations = "clouds-default",
			count = 3,
			ratio = 0.8
		},
		{
			clouds = "assets/clouds.png",
			animations = "clouds-default",
			count = 3,
			ratio = 0.7
		},
		{
			ratio = 0,
			background = "assets/backgrounds/default.png"
		},
		{
			x = -91,
			y = 0,
			platform = "default-big"
		},
		{
			x = 114,
			y = 50,
			platform = "default-side"
		},
		{
			x = -166,
			y = 50,
			platform = "default-side"
		},
		{
			x = -17,
			y = -50,
			platform = "default-top"
		}
	}
}
