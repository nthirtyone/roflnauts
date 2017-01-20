-- The abyss of the alpha.
local animations_small = {
	default = {
		[1] = love.graphics.newQuad(0, 0, 60,20, 600,20),
		[2] = love.graphics.newQuad(60, 0, 60,20, 600,20),
		[3] = love.graphics.newQuad(120, 0, 60,20, 600,20),
		[4] = love.graphics.newQuad(180, 0, 60,20, 600,20),
		[5] = love.graphics.newQuad(240, 0, 60,20, 600,20),
		[6] = love.graphics.newQuad(300, 0, 60,20, 600,20),
		[7] = love.graphics.newQuad(360, 0, 60,20, 600,20),
		[8] = love.graphics.newQuad(420, 0, 60,20, 600,20),
		[9] = love.graphics.newQuad(480, 0, 60,20, 600,20),
		[10] = love.graphics.newQuad(540, 0, 60,20, 600,20),
		frames = 10,
		repeated = true
	}
}
return {
	-- GENERAL
	name = "alpha abyss",
	theme = "alpha.ogg",
	center_x = 0,
	center_y = -80,
	width  = 360,
	height = 240,
	-- RESPAWN POINTS
	respawns = {
		{x = -30, y = 0},
		{x =  30, y = 0},
		{x =   0, y = 0},
		{x = -120, y = -50},
		{x = 120, y = -50},
		{x =  0, y = -75}
	},
	-- GRAPHICS
	clouds = false,
	background = "assets/backgrounds/alpha-1.png",
	platforms = {
		{
			x = -60,
			y = 0,
			shape = {0,0, 117,0, 101,50, 16,50},
			sprite = "assets/platforms/alpha-big-1.png"
		},
		{
			x = -145,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small.png",
			animations = animations_small
		},
		{
			x = 85,
			y = -50,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small.png",
			animations = animations_small
		},
		{
			x = -30,
			y = -80,
			shape = {0,0, 59,0, 59,19, 0,19},
			sprite = "assets/platforms/alpha-small.png",
			animations = animations_small
		}
	},
	decorations = {}
}
