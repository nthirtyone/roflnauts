return
{
	name = "AI Station 404",
	theme = "404.ogg",
	portrait = 8, -- TODO: See `maps/ribbit`.
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
			ratio = 0,
			background = "assets/backgrounds/404.png",
		},
		{
			x = -105,
			y = -75,
			platform = "404-top"
		},
		{
			x = -123,
			y = 25,
			platform = "404-bottom"
		},
		{
			x = 138,
			y = -25,
			platform = "404-small"
		},
		{
			x = -180,
			y = -25,
			platform = "404-small"
		},
		{
			x = 138,
			y = 65,
			platform = "404-small"
		},
		{
			x = -180,
			y = 65,
			platform = "404-small"
		}
	}
}