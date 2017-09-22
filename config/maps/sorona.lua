return
{
	name = "Sorona",
	theme = "sorona.ogg",
	portrait = "assets/maps/sorona.png",
	available = true,
	center = {x = 0, y = 0},
	width  = 360,
	height = 240,
	respawns = {
		{x = -10, y = -20},
		{x = 0, y = -20},
		{x = 10, y = -20}
	},
	create = {
		{
			ratio = 0,
			background = "assets/backgrounds/sorona.png",
		},
		{
			x = -71,
			y = 50,
			platform = "sorona-wide"
		},
		{
			x = -84,
			y = -5,
			platform = "sorona-small"
		},
		{
			x = -50,
			y = -4,
			decoration = "assets/decorations/sorona-bridge-left.png"
		},
		{
			x = -14,
			y = -4,
			decoration = "assets/decorations/sorona-bridge-loop.png"
		},
		{
			x = 14,
			y = -4,
			decoration = "assets/decorations/sorona-bridge-right.png"
		},
		{
			x = 43,
			y = -5,
			platform = "sorona-small"
		}
	}
}
