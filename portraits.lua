-- Spritesheet for character portraits
-- Original size: 331x199 (say what?)
-- Single size: 32x32 1px border merged between
local w, h = 331, 199
return {
	empty = {
		normal = love.graphics.newQuad(298,133,32,32,w,h),
		active = love.graphics.newQuad(298,166,32,32,w,h)
	},
	frog = {
		normal = love.graphics.newQuad(  1,  1,32,32,w,h),
		active = love.graphics.newQuad(  1, 34,32,32,w,h)
	},
	lonestar = {
		normal = love.graphics.newQuad( 34,  1,32,32,w,h),
		active = love.graphics.newQuad( 34, 34,32,32,w,h)
	},
	leon = {
		normal = love.graphics.newQuad( 67,  1,32,32,w,h),
		active = love.graphics.newQuad( 67, 34,32,32,w,h)
	},
	coco = {
		normal = love.graphics.newQuad(  1, 67,32,32,w,h),
		active = love.graphics.newQuad(  1,100,32,32,w,h)
	},
	derpl = {
		normal = love.graphics.newQuad(100, 67,32,32,w,h),
		active = love.graphics.newQuad(100,100,32,32,w,h)
	},
	voltar = {
		normal = love.graphics.newQuad(265,  1,32,32,w,h),
		active = love.graphics.newQuad(265, 34,32,32,w,h)
	},
	yuri = {
		normal = love.graphics.newQuad( 67, 67,32,32,w,h),
		active = love.graphics.newQuad( 67,100,32,32,w,h)
	},
	clunk = {
		normal = love.graphics.newQuad(232,  1,32,32,w,h),
		active = love.graphics.newQuad(232, 34,32,32,w,h)
	}
}