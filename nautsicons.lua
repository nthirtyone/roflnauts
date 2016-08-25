-- Spritesheet for character portraits
-- Original size: 331x265 (say what?)
-- Single size: 32x32 1px border merged between
local w, h = 331, 265
return {
	-- EMPTY
	empty = love.graphics.newQuad(300,136,28,28,w,h),
	-- 1. ROW
	froggo  = love.graphics.newQuad(  3,  4,28,28,w,h),
	cowboy  = love.graphics.newQuad( 36,  4,28,28,w,h),
	honic   = love.graphics.newQuad( 69,  4,28,28,w,h),
	gelato  = love.graphics.newQuad(102,  4,28,28,w,h),
	veno    = love.graphics.newQuad(135,  4,28,28,w,h),
	lady    = love.graphics.newQuad(168,  4,28,28,w,h),
	girl    = love.graphics.newQuad(201,  4,28,28,w,h),
	megoman = love.graphics.newQuad(234,  4,28,28,w,h),
	brainos = love.graphics.newQuad(267,  4,28,28,w,h),
	-- 2. ROW
	woman    = love.graphics.newQuad(  3, 70,28,28,w,h),
	bison    = love.graphics.newQuad( 36, 70,28,28,w,h),
	bobito   = love.graphics.newQuad( 69, 70,28,28,w,h),
	slugzor  = love.graphics.newQuad(102, 70,28,28,w,h),
	capone   = love.graphics.newQuad(135, 70,28,28,w,h),
	bug      = love.graphics.newQuad(168, 70,28,28,w,h),
	calamari = love.graphics.newQuad(201, 70,28,28,w,h),
	quack    = love.graphics.newQuad(234, 70,28,28,w,h),
	scissors = love.graphics.newQuad(267, 70,28,28,w,h),
	-- 3. ROW
	marine     = love.graphics.newQuad(  3, 136,28,28,w,h),
	scooter    = love.graphics.newQuad( 36, 136,28,28,w,h),
	phonebooth = love.graphics.newQuad( 69, 136,28,28,w,h),
	weed       = love.graphics.newQuad(102, 136,28,28,w,h),
	gummybear  = love.graphics.newQuad(135, 136,28,28,w,h),
	gramps     = love.graphics.newQuad(168, 136,28,28,w,h),
	biker      = love.graphics.newQuad(201, 136,28,28,w,h),
	vrooom     = love.graphics.newQuad(234, 136,28,28,w,h),
	link       = love.graphics.newQuad(267, 136,28,28,w,h),
	-- 4. ROW
	gorilla = love.graphics.newQuad(  3,202,28,28,w,h),
	nemo    = love.graphics.newQuad( 36,202,28,28,w,h),
	rock    = love.graphics.newQuad( 69,202,28,28,w,h),
	boss    = love.graphics.newQuad(102,202,28,28,w,h),
	-- ARROWS
	arrow_left  = love.graphics.newQuad(298,1,4,6,w,h),
	arrow_right = love.graphics.newQuad(303,1,4,6,w,h)
}
