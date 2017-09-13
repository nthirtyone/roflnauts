return
{
	name = "Starstorm",
	theme = "starstorm.ogg",
	portrait = 4, -- TODO: See `maps/ribbit`.
	center = {x = 0, y = -20},
	width  = 400,
	height = 260,
	respawns = {
		{x = 100, y = 45},
		{x = -100, y = 45},
		{x = -90, y = -25},
		{x = 90, y = -25},
		{x = -110, y = -70},
		{x = 110, y = -70}
	},
	create = {
		{
			ratio = 0,
			background = "assets/backgrounds/starstorm.png"
		},
		{
			x = -170,
			y = -55,
			platform = "starstorm-left-top"
		},
		{
			x = -156,
			y = -2,
			platform = "starstorm-left-middle"
		},
		{
			x = -160,
			y = 69,
			platform = "starstorm-left-bottom"
		},
		{
			x = 52,
			y = -55,
			platform = "starstorm-right-top"
		},
		{
			x = 44,
			y = -2,
			platform = "starstorm-right-middle"
		},
		{
			x = 55,
			y = 69,
			platform = "starstorm-right-bottom"
		},
		{
			x = -27,
			y = 40,
			platform = "starstorm-center"
		},
		{
			x = -166,
			y = -37,
			decoration = "assets/decorations/starstorm-left-top.png"
		},
		{
			x = -163,
			y = 19,
			decoration = "assets/decorations/starstorm-left-bottom.png"
		},
		{
			x = 119,
			y = -37,
			decoration = "assets/decorations/starstorm-right-top.png"
		},
		{
			x = 129,
			y = 19,
			decoration = "assets/decorations/starstorm-right-bottom.png"
		}
	}
}
