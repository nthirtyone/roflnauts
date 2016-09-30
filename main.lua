-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Pretend you didn't see this
-- This is work for scene manager
Scene = nil
function changeScene(scene)
	if Scene ~= nil then
		Scene:delete()
	end
	Scene = scene
end

-- Should be moved to scene/camera
function getScale()
	return math.max(1, math.floor(math.max(love.graphics.getWidth() / 320, love.graphics.getHeight() / 180)))
end
function getRealScale()
	return math.max(1, math.max(love.graphics.getWidth() / 320, love.graphics.getHeight() / 180))
end
-- Should be moved to Sprite metaclass (non-existent yet)
function newImage(path)
	local imagedata = love.image.newImageData(path)
	local transparency = function(x, y, r, g, b, a)
		if (r == 0 and g == 128 and b == 64) or
		   (r == 0 and g == 240 and b ==  6) then
			a = 0
		end
		return r, g, b, a
	end
	imagedata:mapPixel(transparency)
	local image = love.graphics.newImage(imagedata)
	return image
end

-- Require
require "world"
require "camera"
require "menu"
require "controller"
require "music"
require "settings"

-- Temporary debug
debug = false

-- LÖVE2D callbacks
function love.load()
	-- Graphics
	love.graphics.setBackgroundColor(90, 90, 90)
	love.graphics.setDefaultFilter("nearest", "nearest")
	-- Font
	Font = love.graphics.newImageFont("assets/font-normal.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,:;-_/\\!@#$%^&*?=+~`|'\"()[]{}<>", -1)
	Bold = love.graphics.newImageFont("assets/font-big.png", " 0123456789AEFILNORSTUW", -2)
	Font:setLineHeight(9/16)
	love.graphics.setFont(Font) 
	-- Modules
	Controller.load()
	Settings.load()
	-- Scene
	Scene = Menu:new()
end
function love.update(dt)
	Scene:update(dt)
end
function love.draw()
	Scene:draw()
	if debug then
		local scale = getScale()
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print("Debug ON", 10, 10, 0, scale, scale)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10+9*scale, 0, scale, scale)
	end
end
-- Pass input to Controller
function love.joystickadded(joystick) Controller.joystickadded(joystick) end
function love.gamepadaxis(joystick, axis, value) Controller.gamepadaxis(joystick, axis, value) end
function love.gamepadpressed(joystick, key) Controller.gamepadpressed(joystick, key) end
function love.gamepadreleased(joystick, key) Controller.gamepadreleased(joystick, key) end
function love.keypressed(key) Controller.keypressed(key) end
function love.keyreleased(key) Controller.keyreleased(key) end

-- Controller callbacks
function Controller.controlpressed(set, action, key)
	-- pass to current Scene
	Scene:controlpressed(set, action, key)
	-- globals
	if key == "escape" then
		love.event.quit()
	end
	if key == "f5" then
		debug = not debug
	end
end
function Controller.controlreleased(set, action, key)
	-- pass to current Scene
	Scene:controlreleased(set, action, key)
end


