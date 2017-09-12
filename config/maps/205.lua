return
{
	name = "AI Station 205",
	theme = "sorona.ogg",
	portrait = 1, -- TODO: See `maps/ribbit`.
	center = {x = 0, y = 0},
	width  = 360,
	height = 240,
	respawns = {
		{x = -10, y = -55},
		{x = 0, y = -55},
		{x = 10, y = -55}
	},
	clouds = false,
	create = {
		{
			x = -36,
			y = -48,
			platform = "205-top"
		},
		{
			x = -36+9,
			y = -48+11,
			decoration = "assets/decorations/205-exhaust-top.png"
		},
		{
			x = -122,
			y = 10,
			platform = "205-left"
		},
		{
			x = -122+49,
			y = 10+2,
			decoration = "assets/decorations/205-exhaust-left.png"
		},
		{
			x = 28,
			y = 10,
			platform = "205-right"
		},
		{
			x = 28+29,
			y = 10+2,
			decoration = "assets/decorations/205-exhaust-right.png"
		}
	}
}
