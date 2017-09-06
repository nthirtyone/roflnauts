return
{
	name = "Aiguillon",
	theme = "aiguillon.ogg",
	portrait = 5, -- TODO: See `maps/ribbit`.
	center = {x = 0, y = 10},
	width  = 370,
	height = 290,
	respawns = {
		{x = -15, y = -80},
		{x = -5, y = -80},
		{x = 5, y = -80},
		{x = 15, y = -80},
	},
	clouds = false,
	create = {
		{
			ratio = 0,
			background = "assets/backgrounds/aiguillon.png"
		},
		{
			x = -108,
			y = 22,
			platform = "aiguillon-wide"
		},
		{
			x = -46,
			y = -19,
			platform = "aiguillon-middle"
		},
		{
			x = -141,
			y = -57,
			platform = "aiguillon-left-big"
		},
		{
			x = -132,
			y = 84,
			platform = "aiguillon-left-small"
		},
		{
			x = 77,
			y = -57,
			platform = "aiguillon-right-big"
		},
		{
			x = 103,
			y = 84,
			platform = "aiguillon-right-small"
		}
	},
}
