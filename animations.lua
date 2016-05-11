-- Animations spritesheet array for `Player`
local animations = {
	idle = {
		[1] = love.graphics.newQuad(  1, 1, 24,24, 376,26),
		frames = 1,
		repeated = true
	},
	walk = {
		[1] = love.graphics.newQuad(  1, 1, 24,24, 376,26),
		[2] = love.graphics.newQuad( 26, 1, 24,24, 376,26),
		[3] = love.graphics.newQuad( 51, 1, 24,24, 376,26),
		[4] = love.graphics.newQuad( 76, 1, 24,24, 376,26),
		frames = 4,
		repeated = true
	},
	attack = {
		[1] = love.graphics.newQuad(101, 1, 24,24, 376,26),
		[2] = love.graphics.newQuad(126, 1, 24,24, 376,26),
		[3] = love.graphics.newQuad(151, 1, 24,24, 376,26),
		frames = 3,
		repeated = false
	},
	attack_up = {
		[1] = love.graphics.newQuad(176, 1, 24,24, 376,26),
		[2] = love.graphics.newQuad(201, 1, 24,24, 376,26),
		[3] = love.graphics.newQuad(226, 1, 24,24, 376,26),
		frames = 3,
		repeated = false
	},
	attack_down = {
		[1] = love.graphics.newQuad(251, 1, 24,24, 376,26),
		[2] = love.graphics.newQuad(276, 1, 24,24, 376,26),
		[3] = love.graphics.newQuad(301, 1, 24,24, 376,26),
		frames = 3,
		repeated = false
	},
	damage = {
		[1] = love.graphics.newQuad(326, 1, 24,24, 376,26),
		[2] = love.graphics.newQuad(326, 1, 24,24, 376,26),
		[3] = love.graphics.newQuad(351, 1, 24,24, 376,26),
		frames = 3,
		repeated = false
	},
}
return animations