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
		w.Nauts[1]:assignController(cont1)
		w.Nauts[2]:assignController(cont2)
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