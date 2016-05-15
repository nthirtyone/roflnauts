-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "world"
require "ground"
require "player"
require "camera"
require "cloud"

-- Temporary debug
debug = false

-- Load
function love.load ()
	-- Graphics
	love.graphics.setBackgroundColor(189, 95, 93)
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- ZU WARUDO!
	w = World:new()
	w:createPlatform(290/2, 180/2, {-91,1, 90,1, 90,10, 5,76, -5,76, -91,10}, "assets/platform_big.png")
	w:createPlatform(290/2+140, 180/2+50, {-26,1, 26,1, 26,30, -26,30}, "assets/platform_small.png")
	w:createPlatform(290/2-140, 180/2+50, {-26,1, 26,1, 26,30, -26,30}, "assets/platform_small.png")
	w:createPlatform(290/2, 180/2-50, {-17,1, 17,1, 17,17, -17,17}, "assets/platform_top.png")
	w:createNaut(290/2-10, 180/2 - 80, "assets/leon.png")
	w:createNaut(290/2+10, 180/2 - 80, "assets/lonestar.png")

	w:randomizeCloud()
	w:randomizeCloud()
	w:randomizeCloud()
	
	-- Temporary settings for second player
	w.Nauts[2].name = "Player2"
	w.Nauts[2].key_left = "a"
	w.Nauts[2].key_right = "d"
	w.Nauts[2].key_up = "w"
	w.Nauts[2].key_down = "s"
	w.Nauts[2].key_jump = "h"
	w.Nauts[2].key_hit = "g"
end

-- Update
function love.update (dt)
	w:update(dt)
end

-- KeyPressed
function love.keypressed (key)
	w:keypressed(key)
	-- Switch hitbox display on/off
	if key == "x" then
		debug = not debug
	end
end

-- KeyReleased
function love.keyreleased(key)
	w:keyreleased(key)
end

-- Draw
function love.draw ()
	w:draw()
end