require "ground"
require "player"

debug = false

function love.load()
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
end

function love.update(dt)
	-- Put world in motion!
	world:update(dt)
	-- Players
	for k,naut in pairs(Nauts) do
		naut:update(dt)
	end
end

function love.keypressed(key)
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

function love.draw()
	-- Draw SOME background
	-- I'm already bored with solid color!
	love.graphics.setColor(193, 100, 99, 255)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 60)
	love.graphics.setColor(179, 82, 80, 255)
	love.graphics.rectangle("fill", 0, 160, love.graphics.getWidth(), 40)
	
	-- Draw ground
	for k,platform in pairs(Platforms) do
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(platform.sprite, platform.body:getX()-math.ceil(platform.sprite:getWidth()/2), platform.body:getY())
		if debug then
			love.graphics.setColor(220, 220, 220, 100)
			love.graphics.polygon("fill", platform.body:getWorldPoints(platform.shape:getPoints()))
		end
	end
	
	-- Draw player
	for k,naut in pairs(Nauts) do
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(naut.sprite, naut.current[naut.frame], naut.body:getX(), naut.body:getY(), naut.rotate, naut.facing, 1, 12, 15)
		if debug then
			love.graphics.setColor(50, 255, 50, 100)
			love.graphics.polygon("fill", naut.body:getWorldPoints(naut.shape:getPoints()))
			love.graphics.setColor(255,255,255,255)
			love.graphics.points(naut.body:getX()+12*naut.facing,naut.body:getY()-2)
			love.graphics.points(naut.body:getX()+6*naut.facing,naut.body:getY()+2)
			love.graphics.points(naut.body:getX()+18*naut.facing,naut.body:getY()+2)
			love.graphics.points(naut.body:getX()+12*naut.facing,naut.body:getY()+6)
		end
	end
end

function beginContact(a, b, coll)
	local x,y = coll:getNormal()
	if y == -1 then
		print(b:getUserData().name .. " is not in air")
		b:getUserData().inAir = false
		b:getUserData().jumpdouble = true
	end
end

function endContact(a, b, coll)
	print(b:getUserData().name .. " is in air")
	b:getUserData().inAir = true
end