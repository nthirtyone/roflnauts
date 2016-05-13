-- "NOTNAUTS"
-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "ground"
require "player"
require "camera"

debug = false

function love.load ()
	-- Graphics
	love.graphics.setBackgroundColor(189, 95, 93)
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	-- World physics
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 9.81*64, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	-- Platforms (`Ground`)
	Platforms = {}
	table.insert(Platforms, Ground:new(world, 290/2, 180/2, {-91,0, 90,0, 90,10, 5,76, -5,76, -91,10}, "assets/platform_big.png"))
	table.insert(Platforms, Ground:new(world, 290/2+140, 180/2+50, {-26,0, 26,0, 26,30, -26,30}, "assets/platform_small.png"))
	table.insert(Platforms, Ground:new(world, 290/2-140, 180/2+50, {-26,0, 26,0, 26,30, -26,30}, "assets/platform_small.png"))
	table.insert(Platforms, Ground:new(world, 290/2, 180/2-50, {-17,0, 17,0, 17,17, -17,17}, "assets/platform_top.png"))
	
	-- Nauts (`Player`)
	Nauts = {}
	table.insert(Nauts, Player:new(world, 290/2-10, 180/2 - 80, "assets/leon.png"))
	table.insert(Nauts, Player:new(world, 290/2+10, 180/2 - 80, "assets/lonestar.png"))
	
	-- Temporary settings for second player
	Nauts[2].name = "Player2"
	Nauts[2].key_left = "a"
	Nauts[2].key_right = "d"
	Nauts[2].key_up = "w"
	Nauts[2].key_down = "s"
	Nauts[2].key_jump = "h"
	Nauts[2].key_hit = "g"
	
	-- Camera
	camera = Camera:new()
end

function love.update (dt)
	-- Put world in motion!
	world:update(dt)
	camera:moveFollow()
	-- Players
	for k,naut in pairs(Nauts) do
		naut:update(dt)
	end
end

function love.keypressed (key)
	-- Switch hitbox display on/off
	if key == "x" then
		debug = not debug
	end
	-- Players
	for k,naut in pairs(Nauts) do
		naut:keypressed(key)
	end
end

function love.keyreleased(key)
	-- Players
	for k,naut in pairs(Nauts) do
		naut:keyreleased(key)
	end
end

function love.draw ()
	-- Draw SOME background
	-- I'm already bored with solid color!
	love.graphics.setColor(193, 100, 99, 255)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 60)
	love.graphics.setColor(179, 82, 80, 255)
	love.graphics.rectangle("fill", 0, 160, love.graphics.getWidth(), 40)
	
	local offset_x, offset_y = camera:getOffsets()
	-- Draw ground
	for k,platform in pairs(Platforms) do
		platform:draw(offset_x, offset_y, debug)
	end
	
	-- Draw player
	for k,naut in pairs(Nauts) do
		naut:draw(offset_x, offset_y, debug)
	end
end

function beginContact (a, b, coll)
	local x,y = coll:getNormal()
	if y == -1 then
		print(b:getUserData().name .. " is not in air")
		b:getUserData().inAir = false
		b:getUserData().jumpdouble = true
	end
end

function endContact (a, b, coll)
	print(b:getUserData().name .. " is in air")
	b:getUserData().inAir = true
end