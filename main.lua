-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "world"
require "camera"
--require "menu"
require "controller"

-- Temporary debug
debug = false
third = nil --"clunk"
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

	-- Controllers
	cont1 = Controller:new()
	cont2 = Controller:new(nil, "a", "d", "w", "s", "g", "h")
	w.Nauts[1]:assignController(cont1)
	w.Nauts[2]:assignController(cont2)

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

	-- Menu bijaczes
	--m = Menu:new()
	--m:newSelector()
end

-- Update
function love.update (dt)
	w:update(dt)
end

-- KeyPressed
function love.keypressed (key)
	w:keypressed(key)
	cont1:keypressed(key)
	cont2:keypressed(key)
	-- Switch hitbox display on/off
	if key == "x" then
		debug = not debug
	end
	if key == "escape" then
		love.event.quit()
	end
	if key == "f5" and debug then
		local new = World:new("default", "leon", "lonestar", third, fourth)
		w = nil
		w = new
	end
end

-- KeyReleased
function love.keyreleased(key)
	w:keyreleased(key)
	cont1:keyreleased(key)
	cont2:keyreleased(key)
end

-- Draw
function love.draw ()
	w:draw()
	--m.selectors[1]:draw()
	if debug then
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	end
end