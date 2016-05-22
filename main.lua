-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "world"
require "ground"
require "player"
require "camera"
require "cloud"
require "effect"

-- Temporary debug
debug = false
third = "clunk"
fourth = nil --"yuri"

-- Load
function love.load ()
	-- Graphics
	love.graphics.setBackgroundColor(189, 95, 93)
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- Font
	Font = love.graphics.newImageFont("assets/font2.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-,!:()[]{}<>", -1)
	Font:setLineHeight(1)
	love.graphics.setFont(Font)
	
	-- ZU WARUDO!
	w = World:new("default", "leon", "lonestar", third, fourth)
	
	-- Temporary settings for second player
	w.Nauts[2].key_left = "a"
	w.Nauts[2].key_right = "d"
	w.Nauts[2].key_up = "w"
	w.Nauts[2].key_down = "s"
	w.Nauts[2].key_jump = "g"
	w.Nauts[2].key_hit = "f"
	
	-- Temporary settings for third player
	if third ~= nil then
	w.Nauts[3].key_left = "kp4"
	w.Nauts[3].key_right = "kp6"
	w.Nauts[3].key_up = "kp8"
	w.Nauts[3].key_down = "kp5"
	w.Nauts[3].key_jump = "kp2"
	w.Nauts[3].key_hit = "kp3"
	end
	
	-- Temporary settings for fourth player
	if fourth ~= nil then
	w.Nauts[4].key_left = "b"
	w.Nauts[4].key_right = "m"
	w.Nauts[4].key_up = "h"
	w.Nauts[4].key_down = "n"
	w.Nauts[4].key_jump = "k"
	w.Nauts[4].key_hit = "l"
	end
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
	if key == "escape" then
		love.event.quit()
	end
end

-- KeyReleased
function love.keyreleased(key)
	w:keyreleased(key)
end

-- Draw
function love.draw ()
	w:draw()
	if debug then
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	end
end