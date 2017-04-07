--- Roflnauts 2
-- TODO: Any lua source file in root directory that is not `main` (this file), `conf` should be moved to a proper directory. Its name should be changed to show what it contains.

-- Pretend you didn't see this
-- This is work for scene manager
-- TODO: Create SceneManager or similar class.
Scene = nil
function changeScene (scene)
	if Scene ~= nil then
		Scene:delete()
	end
	Scene = scene
end

-- Should be moved to scene/camera
-- TODO: move following functions to `Camera`.
function getScale ()
	return math.max(1, math.floor(math.max(love.graphics.getWidth() / 320, love.graphics.getHeight() / 180)))
end

function getRealScale ()
	return math.max(1, math.max(love.graphics.getWidth() / 320, love.graphics.getHeight() / 180))
end

-- Require
require "not.World"
require "not.Camera"
require "not.Menu"
require "not.Controller"
require "not.Settings"

-- Temporary debug
debug = false

-- LÖVE2D callbacks
function love.load ()
	love.graphics.setBackgroundColor(90, 90, 90)
	love.graphics.setDefaultFilter("nearest", "nearest")
	-- TODO: Move fonts somewhere else out of global scope.
	Font = love.graphics.newImageFont("assets/font-normal.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,:;-_/\\!@#$%^&*?=+~`|'\"()[]{}<>", -1)
	Bold = love.graphics.newImageFont("assets/font-big.png", " 0123456789AEFILNORSTUW", -2)
	Font:setLineHeight(9/16)
	love.graphics.setFont(Font)
	Controller.load()
	Settings.load()
	Scene = Menu:new()
end

function love.draw ()
	Scene:draw()
	if debug then
		local scale = getScale()
		love.graphics.setFont(Font)
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print("Debug ON", 10, 10, 0, scale, scale)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10+9*scale, 0, scale, scale)
	end
end

function love.update (dt) Scene:update(dt) end
function love.quit () Settings.save() end

-- Pass input to Controller
function love.gamepadaxis (joystick, axis, value) Controller.gamepadaxis(joystick, axis, value) end
function love.gamepadpressed (joystick, key) Controller.gamepadpressed(joystick, key) end
function love.gamepadreleased (joystick, key) Controller.gamepadreleased(joystick, key) end
function love.keypressed (key) Controller.keypressed(key) end
function love.keyreleased (key) Controller.keyreleased(key) end

-- Controller callbacks
function Controller.controlpressed (set, action, key)
	Scene:controlpressed(set, action, key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "f5" then
		debug = not debug
	end
end

function Controller.controlreleased (set, action, key)
	Scene:controlreleased(set, action, key)
end