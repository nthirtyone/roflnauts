return
{
	name = "Rill",
	theme = "rill.ogg",
	portrait = "assets/maps/rill.png",
	center = {x = 0, y = 75},
	width  = 400,
	height = 260,
	respawns = {
		{x = -135, y = 10},
		{x = -135, y = 10},
		{x =  135, y = 10},
		{x =  135, y = 10}
	},
	create = {
		{
			ratio = 0,
			background = "assets/backgrounds/rill.png"
		},
		{
			x = -151,
			y = 25,
			platform = "rill-flat-left"
		},
		{
			x = 93,
			y = 25,
			platform = "rill-flat-right"
		},
		{
			x = -24,
			y = 55,
			platform = "rill-center"
		},
		{
			x = -112,
			y = 80,
			platform = "rill-slope-left"
		},
		{
			x = 35,
			y = 80,
			platform = "rill-slope-right"
		},
		{
			x = 98,
			y = -20,
			decoration = "assets/decorations/rill-lollipop-big-purple.png"
		},
		{
			x = 127,
			y = 4,
			decoration = "assets/decorations/rill-lollipop-small-green.png"
		},
		{
			x = -152,
			y = -20,
			decoration = "assets/decorations/rill-lollipop-big-orange.png"
		},
		{
			x = -121,
			y = 4,
			decoration = "assets/decorations/rill-lollipop-small-blue.png"
		}
	}
}
