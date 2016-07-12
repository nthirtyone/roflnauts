-- Spritesheet for character portraits
-- Original size: 331x265 (say what?)
-- Single size: 32x32 1px border merged between
local w, h = 331, 220
return {
	-- EMPTY
	empty = {
		normal = love.graphics.newQuad(298,133,32,32,w,h),
		active = love.graphics.newQuad(298,166,32,32,w,h)
	},
	-- 1. ROW
	froggo = {
		normal = love.graphics.newQuad(  1,  1,32,32,w,h),
		active = love.graphics.newQuad(  1, 34,32,32,w,h)
	},
	cowboy = {
		normal = love.graphics.newQuad( 34,  1,32,32,w,h),
		active = love.graphics.newQuad( 34, 34,32,32,w,h)
	},
	honic = {
		normal = love.graphics.newQuad( 67,  1,32,32,w,h),
		active = love.graphics.newQuad( 67, 34,32,32,w,h)
	},
	gelato = {
		normal = love.graphics.newQuad(100,  1,32,32,w,h),
		active = love.graphics.newQuad(100, 34,32,32,w,h)
	},
	veno = {
		normal = love.graphics.newQuad(133,  1,32,32,w,h),
		active = love.graphics.newQuad(133, 34,32,32,w,h)
	},
	lady = {
		normal = love.graphics.newQuad(166,  1,32,32,w,h),
		active = love.graphics.newQuad(166, 34,32,32,w,h)
	},
	girl = {
		normal = love.graphics.newQuad(199,  1,32,32,w,h),
		active = love.graphics.newQuad(199, 34,32,32,w,h)
	},
	megoman = {
		normal = love.graphics.newQuad(232,  1,32,32,w,h),
		active = love.graphics.newQuad(232, 34,32,32,w,h)
	},
	brainos = {
		normal = love.graphics.newQuad(265,  1,32,32,w,h),
		active = love.graphics.newQuad(265, 34,32,32,w,h)
	},
	-- 2. ROW
	woman = {
		normal = love.graphics.newQuad(  1, 67,32,32,w,h),
		active = love.graphics.newQuad(  1,100,32,32,w,h)
	},
	bison = {
		normal = love.graphics.newQuad( 34, 67,32,32,w,h),
		active = love.graphics.newQuad( 34,100,32,32,w,h)
	},
	bobito = {
		normal = love.graphics.newQuad( 67, 67,32,32,w,h),
		active = love.graphics.newQuad( 67,100,32,32,w,h)
	},
	slugzor = {
		normal = love.graphics.newQuad(100, 67,32,32,w,h),
		active = love.graphics.newQuad(100,100,32,32,w,h)
	},
	capone = {
		normal = love.graphics.newQuad(133, 67,32,32,w,h),
		active = love.graphics.newQuad(133,100,32,32,w,h)
	},
	bug = {
		normal = love.graphics.newQuad(166, 67,32,32,w,h),
		active = love.graphics.newQuad(166,100,32,32,w,h)
	},
	calamari = {
		normal = love.graphics.newQuad(199, 67,32,32,w,h),
		active = love.graphics.newQuad(199,100,32,32,w,h)
	},
	quack = {
		normal = love.graphics.newQuad(232, 67,32,32,w,h),
		active = love.graphics.newQuad(232,100,32,32,w,h)
	},
	scissors = {
		normal = love.graphics.newQuad(265, 67,32,32,w,h),
		active = love.graphics.newQuad(265,100,32,32,w,h)
	},
	-- 3. ROW
	marine = {
		normal = love.graphics.newQuad(  1,133,32,32,w,h),
		active = love.graphics.newQuad(  1,166,32,32,w,h)
	},
	scooter = {
		normal = love.graphics.newQuad( 34,133,32,32,w,h),
		active = love.graphics.newQuad( 34,166,32,32,w,h)
	},
	phonebooth = {
		normal = love.graphics.newQuad( 67,133,32,32,w,h),
		active = love.graphics.newQuad( 67,166,32,32,w,h)
	},
	weed = {
		normal = love.graphics.newQuad(100,133,32,32,w,h),
		active = love.graphics.newQuad(100,166,32,32,w,h)
	},
	gummybear = {
		normal = love.graphics.newQuad(133,133,32,32,w,h),
		active = love.graphics.newQuad(133,166,32,32,w,h)
	},
	gramps = {
		normal = love.graphics.newQuad(166,133,32,32,w,h),
		active = love.graphics.newQuad(166,166,32,32,w,h)
	},
	biker = {
		normal = love.graphics.newQuad(199,133,32,32,w,h),
		active = love.graphics.newQuad(199,166,32,32,w,h)
	},
	vrooom = {
		normal = love.graphics.newQuad(232,133,32,32,w,h),
		active = love.graphics.newQuad(232,166,32,32,w,h)
	},
	link = {
		normal = love.graphics.newQuad(265,133,32,32,w,h),
		active = love.graphics.newQuad(265,166,32,32,w,h)
	},
	-- 4. ROW
	gorilla = {
		normal = love.graphics.newQuad(  1,199,32,32,w,h),
		active = love.graphics.newQuad(  1,232,32,32,w,h)
	},
	nemo = {
		normal = love.graphics.newQuad( 34,199,32,32,w,h),
		active = love.graphics.newQuad( 34,232,32,32,w,h)
	},
	rock = {
		normal = love.graphics.newQuad( 67,199,32,32,w,h),
		active = love.graphics.newQuad( 67,232,32,32,w,h)
	},
	boss = {
		normal = love.graphics.newQuad(100,199,32,32,w,h),
		active = love.graphics.newQuad(100,232,32,32,w,h)
	},
	-- ARROWS
	arrow_left  = love.graphics.newQuad(298,1,4,6,w,h),
	arrow_right = love.graphics.newQuad(303,1,4,6,w,h)
}
