--- Generates clouds over time with randomized positions and styles.
-- Also used as factory for Clouds.
CloudGenerator = require "not.Object":extends()

require "not.Cloud"

local animations = { 
	default = {
		[1] = love.graphics.newQuad(  1,  1, 158,47, 478,49),
		frames = 1,
		repeated = true
	},
	default2 = {
		[1] = love.graphics.newQuad(160,  1, 158,47, 478,49),
		frames = 1,
		repeated = true
	},
	default3 = {
		[1] = love.graphics.newQuad(319,  1, 158,47, 478,49),
		frames = 1,
		repeated = true
	}
}

-- TODO: Allow map config to modify cloud styles: maximum cloud count, animations and atlas.
function CloudGenerator:new (world)
	self.world = world
	self.atlas = "assets/clouds.png"
	self.quads = animations
	self.count = 18
	self.interval = 6
	self.timer = 0
end

function CloudGenerator:createCloud (x, y, style)
	local cloud = Cloud(x, y, self.world, self.atlas)
	cloud:setAnimationsList(self.quads)
	cloud:setAnimation(style)
	cloud:setVelocity(13, 0)
	cloud:setBoundary(340, 320)
	return cloud
end

-- TODO: CloudGen's randomization methods are too static (not configurable).
function CloudGenerator:getRandomPosition (inside)
	local x, y
	local map = self.world.map
	if not inside then
		x = map.center.x - map.width*1.2 + love.math.random(-50, 20)
	else
		x = love.math.random(map.center.x - map.width / 2, map.center.x + map.width / 2)
	end
	y = love.math.random(map.center.y - map.height / 2, map.center.y + map.height / 2)
	return x, y
end

function CloudGenerator:getRandomStyle ()
	local num = love.math.random(1, 3)
	local style = "default"
	if num > 1 then
		style = style .. tostring(num)
	end
	return style
end

function CloudGenerator:run (count, inside)
	local count = count or 1
	for i=1,count do
		local x, y = self:getRandomPosition(inside)
		local style = self:getRandomStyle()
		self.world:insertCloud(self:createCloud(x, y, style))
	end
end

function CloudGenerator:update (dt)
	local count = self.world:getCloudsCount()
	self.timer = self.timer - dt
	if self.timer < 0 then
		self.timer = self.timer + self.interval
		self:run()
	end
end

return CloudGenerator
