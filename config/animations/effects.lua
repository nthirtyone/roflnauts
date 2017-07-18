-- Animations spritesheet array for `Effect`
-- Size of sprie atlas is 168px x 144px

-- NAME      :POSITION :SIZE :FRAMES
-- jump      :x  0 y  0: 24px: 4
-- doublejump:x  0 y 24: 24px: 4
-- land      :x  0 y 48: 24px: 5
-- respawn   :x  0 y 72: 24px: 7
-- clash     :x  0 y 96: 24px: 6
-- trail     :x  0 y120: 24px: 4
-- hit       :x 96 y  0: 24px: 3

local quads = {
	jump = {
		[1] = love.graphics.newQuad(  0,  0, 24,24, 168,144),
		[2] = love.graphics.newQuad( 24,  0, 24,24, 168,144),
		[3] = love.graphics.newQuad( 48,  0, 24,24, 168,144),
		[4] = love.graphics.newQuad( 72,  0, 24,24, 168,144),
		frames = 4,
		repeated = false
	},
	doublejump = {
		[1] = love.graphics.newQuad(  0, 24, 24,24, 168,144),
		[2] = love.graphics.newQuad( 24, 24, 24,24, 168,144),
		[3] = love.graphics.newQuad( 48, 24, 24,24, 168,144),
		[4] = love.graphics.newQuad( 72, 24, 24,24, 168,144),
		frames = 4,
		repeated = false
	},
	land = {
		[1] = love.graphics.newQuad(  0, 48, 24,24, 168,144),
		[2] = love.graphics.newQuad( 24, 48, 24,24, 168,144),
		[3] = love.graphics.newQuad( 48, 48, 24,24, 168,144),
		[4] = love.graphics.newQuad( 72, 48, 24,24, 168,144),
		[5] = love.graphics.newQuad( 96, 48, 24,24, 168,144),
		frames = 5,
		repeated = false
	},
	respawn = {
		[1] = love.graphics.newQuad(  0, 72, 24,24, 168,144),
		[2] = love.graphics.newQuad( 24, 72, 24,24, 168,144),
		[3] = love.graphics.newQuad( 48, 72, 24,24, 168,144),
		[4] = love.graphics.newQuad( 72, 72, 24,24, 168,144),
		[5] = love.graphics.newQuad( 96, 72, 24,24, 168,144),
		[6] = love.graphics.newQuad(120, 72, 24,24, 168,144),
		[7] = love.graphics.newQuad(144, 72, 24,24, 168,144),
		frames = 7,
		repeated = false
	},
	clash = {
		[1] = love.graphics.newQuad(  0, 96, 24,24, 168,144),
		[2] = love.graphics.newQuad( 24, 96, 24,24, 168,144),
		[3] = love.graphics.newQuad( 48, 96, 24,24, 168,144),
		[4] = love.graphics.newQuad( 72, 96, 24,24, 168,144),
		[5] = love.graphics.newQuad( 96, 96, 24,24, 168,144),
		[6] = love.graphics.newQuad(120, 96, 24,24, 168,144),
		frames = 6,
		repeated = false
	},
	trail = {
		[1] = love.graphics.newQuad(  0,120, 24,24, 168,144),
		[2] = love.graphics.newQuad( 24,120, 24,24, 168,144),
		[3] = love.graphics.newQuad( 48,120, 24,24, 168,144),
		[4] = love.graphics.newQuad( 72,120, 24,24, 168,144),
		frames = 4,
		repeated = false
	},
	hit = {
		[1] = love.graphics.newQuad( 96,  0, 24,24, 168,144),
		[2] = love.graphics.newQuad(120,  0, 24,24, 168,144),
		[3] = love.graphics.newQuad(144,  0, 24,24, 168,144),
		frames = 3,
		repeated = false
	}
}
return quads
