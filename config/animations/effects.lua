-- Animations spritesheet array for `Effect`
-- Size of sprie atlas is 168px x 120px

-- NAME      :POSITION :SIZE :FRAMES
-- jump      :x  0 y  0: 24px: 4
-- doublejump:x  0 y 24: 24px: 4
-- land      :x  0 y 48: 24px: 5
-- respawn   :x  0 y 72: 24px: 7
-- clash     :x  0 y 96: 24px: 6
-- trail     :x104 y  0: 16px: 4
-- hit       :x106 y 18: 16px: 3

local quads = {
	jump = {
		[1] = love.graphics.newQuad(  0,  0, 24,24, 168,120),
		[2] = love.graphics.newQuad( 24,  0, 24,24, 168,120),
		[3] = love.graphics.newQuad( 48,  0, 24,24, 168,120),
		[4] = love.graphics.newQuad( 72,  0, 24,24, 168,120),
		frames = 4,
		repeated = false
	},
	doublejump = {
		[1] = love.graphics.newQuad(  0, 24, 24,24, 168,120),
		[2] = love.graphics.newQuad( 24, 24, 24,24, 168,120),
		[3] = love.graphics.newQuad( 48, 24, 24,24, 168,120),
		[4] = love.graphics.newQuad( 72, 24, 24,24, 168,120),
		frames = 4,
		repeated = false
	},
	land = {
		[1] = love.graphics.newQuad(  0, 48, 24,24, 168,120),
		[2] = love.graphics.newQuad( 24, 48, 24,24, 168,120),
		[3] = love.graphics.newQuad( 48, 48, 24,24, 168,120),
		[4] = love.graphics.newQuad( 72, 48, 24,24, 168,120),
		[5] = love.graphics.newQuad( 96, 48, 24,24, 168,120),
		frames = 5,
		repeated = false
	},
	respawn = {
		[1] = love.graphics.newQuad(  0, 72, 24,24, 168,120),
		[2] = love.graphics.newQuad( 24, 72, 24,24, 168,120),
		[3] = love.graphics.newQuad( 48, 72, 24,24, 168,120),
		[4] = love.graphics.newQuad( 72, 72, 24,24, 168,120),
		[5] = love.graphics.newQuad( 96, 72, 24,24, 168,120),
		[6] = love.graphics.newQuad(120, 72, 24,24, 168,120),
		[7] = love.graphics.newQuad(144, 72, 24,24, 168,120),
		frames = 7,
		repeated = false
	},
	clash = {
		[1] = love.graphics.newQuad(  0, 96, 24,24, 168,120),
		[2] = love.graphics.newQuad( 24, 96, 24,24, 168,120),
		[3] = love.graphics.newQuad( 48, 96, 24,24, 168,120),
		[4] = love.graphics.newQuad( 72, 96, 24,24, 168,120),
		[5] = love.graphics.newQuad( 96, 96, 24,24, 168,120),
		[6] = love.graphics.newQuad(120, 96, 24,24, 168,120),
		frames = 6,
		repeated = false
	},
	trail = {
		[1] = love.graphics.newQuad(104,  0, 16,16, 168,120),
		[2] = love.graphics.newQuad(120,  0, 16,16, 168,120),
		[3] = love.graphics.newQuad(136,  0, 16,16, 168,120),
		[4] = love.graphics.newQuad(152,  0, 16,16, 168,120),
		frames = 4,
		repeated = false
	},
	hit = {
		[1] = love.graphics.newQuad(106, 18, 16,16, 168,120),
		[2] = love.graphics.newQuad(122, 18, 16,16, 168,120),
		[3] = love.graphics.newQuad(138, 18, 16,16, 168,120),
		frames = 3,
		repeated = false
	}
}
return quads