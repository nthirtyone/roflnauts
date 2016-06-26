-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Pretend you didn't see this
Scene = nil
function changeScene(scene)
	Scene = scene
end

function getScale()
	return math.max(1, math.floor(love.graphics.getWidth() / 320)-1, math.floor(love.graphics.getHeight() / 180)-1)
end
function getRealScale()
	return math.max(love.graphics.getWidth() / 320, love.graphics.getHeight() / 180)
end

-- Require
require "world"
require "camera"
require "menu"
require "controller"

-- Temporary debug
debug = false

-- Load
function love.load ()
	-- Graphics
	love.graphics.setBackgroundColor(189, 95, 93)
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Font
	Font = love.graphics.newImageFont("assets/font2.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.-,!:()[]{}<>", -1)
	Bold = love.graphics.newImageFont("assets/font3.png", " 0123456789AEFILNORSTUW", -2)
	Font:setLineHeight(1)
	love.graphics.setFont(Font)

	-- Menu bijaczes
	m = Menu:new()

	-- Controllers
	Controllers = {}
	table.insert(Controllers, Controller:new())
	table.insert(Controllers, Controller:new(nil, "a", "d", "w", "s", "g", "h"))
	m:assignController(Controllers[1])
	m:assignController(Controllers[2])

	-- Scene
	changeScene(m)
end

-- Gamepad
function love.joystickadded(joystick)
	love.joystick.loadGamepadMappings("gamecontrollerdb.txt")
	table.insert(Controllers, Controller:new(joystick, "dpleft", "dpright", "dpup", "dpdown", "a", "b"))
	m:assignController(Controllers[#Controllers])
end

function love.gamepadpressed(joystick, button)
	print(button, "pressed")
	for _,controller in pairs(Controllers) do
		controller:gamepadpressed(joystick, button)
	end
end

function love.gamepadreleased(joystick, button)
	print(button, "released")
	for _,controller in pairs(Controllers) do
		controller:gamepadreleased(joystick, button)
	end
end

-- Update
function love.update (dt)
	Scene:update(dt)
end

-- KeyPressed
function love.keypressed (key)
	-- Controllers
	for _,controller in pairs(Controllers) do
		controller:keypressed(key)
	end
	-- Misc global input
	if key == "x" then
		debug = not debug
	end
	if key == "escape" or key == "f1" then
		love.event.quit()
	end
	if key == "f5" and debug then
		local new = World:new("default", {"leon", Controllers[1]}, {"lonestar", Controllers[2]})
		Scene:delete()
		changeScene(new)
	end
end

-- KeyReleased
function love.keyreleased(key)
	-- Controllers
	for _,controller in pairs(Controllers) do
		controller:keyreleased(key)
	end
end

-- Draw
function love.draw ()
	Scene:draw()
	if debug then
		love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
	end
end