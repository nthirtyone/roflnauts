-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Pretend you didn't see this
-- This is work for scene manager
Scene = nil
function changeScene(scene)
	Scene = scene
end

-- Should be moved to scene/camera
function getScale()
	return getRealScale()
	--return math.max(1, math.floor(love.graphics.getWidth() / 320)-1, math.floor(love.graphics.getHeight() / 180)-1)
end
function getRealScale()
	return math.max(love.graphics.getWidth() / 320, love.graphics.getHeight() / 180)
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

-- Temporary debug
debug = false

-- Load
function love.load()
	-- Graphics
	love.graphics.setBackgroundColor(90, 90, 90)
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Font
	Font = love.graphics.newImageFont("assets/font-normal.png", " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,:;-_/\\!@#$%^&*?=+~`|'\"()[]{}<>", -1)
	Bold = love.graphics.newImageFont("assets/font-big.png", " 0123456789AEFILNORSTUW", -2)
	Font:setLineHeight(9/16)
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
function love.update(dt)
	Scene:update(dt)
end

-- KeyPressed
function love.keypressed(key)
	-- Controllers
	for _,controller in pairs(Controllers) do
		controller:keypressed(key)
	end
	-- Misc global input
	if key == "f5" then
		debug = not debug
	end
	if key == "escape" or key == "f1" then
		love.event.quit()
	end
	if key == "f6" and debug then
		local map = Scene:getMapName()
		local nauts = {}
		for _,naut in pairs(Scene:getNautsAll()) do
			table.insert(nauts, {naut.name, naut.controller})
		end
		local new = World:new(map, nauts)
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
