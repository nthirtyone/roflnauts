return
{
	name = "starstorm",
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
	clouds = false,
	background = "assets/backgrounds/starstorm.png",
	platforms = {
		{
			x = -170,
			y = -55,
			config = "starstorm-left-top"
		},
		{
			x = -156,
			y = -2,
			config = "starstorm-left-middle"
		},
		{
			x = -160,
			y = 69,
			config = "starstorm-left-bottom"
		},
		{
			x = 52,
			y = -55,
			config = "starstorm-right-top"
		},
		{
			x = 44,
			y = -2,
			config = "starstorm-right-middle"
		},
		{
			x = 55,
			y = 69,
			config = "starstorm-right-bottom"
		},
		{
			x = -27,
			y = 40,
			config = "starstorm-center"
		}
	},
	decorations = {
		{
			x = -166,
			y = -37,
			sprite = "assets/decorations/starstorm-left-top.png"
		},
		{
			x = -163,
			y = 19,
			sprite = "assets/decorations/starstorm-left-bottom.png"
		},
		{
			x = 119,
			y = -37,
			sprite = "assets/decorations/starstorm-right-top.png"
		},
		{
			x = 52+77,
			y = 19,
			sprite = "assets/decorations/starstorm-right-bottom.png"
		}
	}
}
