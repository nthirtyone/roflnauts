-- Spritesheet for character portraits
-- Original size: 331x199 (say what?)
-- Single size: 32x32 1px border merged between
local w, h = 331, 220
return {
	-- EMPTY
	empty = {
		normal = love.graphics.newQuad(298,133,32,32,w,h),
		active = love.graphics.newQuad(298,166,32,32,w,h)
	},
	-- 1. ROW
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
	scoop = {
		normal = love.graphics.newQuad(100,  1,32,32,w,h),
		active = love.graphics.newQuad(100, 34,32,32,w,h)
	},
	gnaw = {
		normal = love.graphics.newQuad(133,  1,32,32,w,h),
		active = love.graphics.newQuad(133, 34,32,32,w,h)
	},
	raelynn = {
		normal = love.graphics.newQuad(166,  1,32,32,w,h),
		active = love.graphics.newQuad(166, 34,32,32,w,h)
	},
	ayla = {
		normal = love.graphics.newQuad(199,  1,32,32,w,h),
		active = love.graphics.newQuad(199, 34,32,32,w,h)
	},
	clunk = {
		normal = love.graphics.newQuad(232,  1,32,32,w,h),
		active = love.graphics.newQuad(232, 34,32,32,w,h)
	},
	voltar = {
		normal = love.graphics.newQuad(265,  1,32,32,w,h),
		active = love.graphics.newQuad(265, 34,32,32,w,h)
	},
	-- 2. ROW
	coco = {
		normal = love.graphics.newQuad(  1, 67,32,32,w,h),
		active = love.graphics.newQuad(  1,100,32,32,w,h)
	},
	skolldir = {
		normal = love.graphics.newQuad( 34, 67,32,32,w,h),
		active = love.graphics.newQuad( 34,100,32,32,w,h)
	},
	yuri = {
		normal = love.graphics.newQuad( 67, 67,32,32,w,h),
		active = love.graphics.newQuad( 67,100,32,32,w,h)
	},
	derpl = {
		normal = love.graphics.newQuad(100, 67,32,32,w,h),
		active = love.graphics.newQuad(100,100,32,32,w,h)
	},
	vinnie = {
		normal = love.graphics.newQuad(133, 67,32,32,w,h),
		active = love.graphics.newQuad(133,100,32,32,w,h)
	},
	genji = {
		normal = love.graphics.newQuad(166, 67,32,32,w,h),
		active = love.graphics.newQuad(166,100,32,32,w,h)
	},
	swiggins = {
		normal = love.graphics.newQuad(199, 67,32,32,w,h),
		active = love.graphics.newQuad(199,100,32,32,w,h)
	},
	rocco = {
		normal = love.graphics.newQuad(232, 67,32,32,w,h),
		active = love.graphics.newQuad(232,100,32,32,w,h)
	},
	ksenia = {
		normal = love.graphics.newQuad(265, 67,32,32,w,h),
		active = love.graphics.newQuad(265,100,32,32,w,h)
	},
	-- 3. ROW
	ted = {
		normal = love.graphics.newQuad(  1,133,32,32,w,h),
		active = love.graphics.newQuad(  1,166,32,32,w,h)
	},
	penny = {
		normal = love.graphics.newQuad( 34,133,32,32,w,h),
		active = love.graphics.newQuad( 34,166,32,32,w,h)
	},
	sentry = {
		normal = love.graphics.newQuad( 67,133,32,32,w,h),
		active = love.graphics.newQuad( 67,166,32,32,w,h)
	},
	skree = {
		normal = love.graphics.newQuad(100,133,32,32,w,h),
		active = love.graphics.newQuad(100,166,32,32,w,h)
	},
	nibbs = {
		normal = love.graphics.newQuad(133,133,32,32,w,h),
		active = love.graphics.newQuad(133,166,32,32,w,h)
	},
	yoolip = {
		normal = love.graphics.newQuad(166,133,32,32,w,h),
		active = love.graphics.newQuad(166,166,32,32,w,h)
	},
	chucho = {
		normal = love.graphics.newQuad(199,133,32,32,w,h),
		active = love.graphics.newQuad(199,166,32,32,w,h)
	},
	lux = {
		normal = love.graphics.newQuad(232,133,32,32,w,h),
		active = love.graphics.newQuad(232,166,32,32,w,h)
	},
	ix = {
		normal = love.graphics.newQuad(265,133,32,32,w,h),
		active = love.graphics.newQuad(265,166,32,32,w,h)
	}
}