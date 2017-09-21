return
{
	default = {
		[1] = love.graphics.newQuad(0, 0, 42, 19, 168, 19),
		[2] = love.graphics.newQuad(42, 0, 42, 19, 168, 19),
		frames = 2,
		repeated = true
	},
	fadein = {
		[1] = love.graphics.newQuad(84, 0, 42, 19, 168, 19),
		[2] = love.graphics.newQuad(126, 0, 42, 19, 168, 19),
		frames = 2,
		repeated = false
	},
	fadeout = {
		[1] = love.graphics.newQuad(126, 0, 42, 19, 168, 19),
		[2] = love.graphics.newQuad(84, 0, 42, 19, 168, 19),
		frames = 2,
		repeated = false
	}
}
