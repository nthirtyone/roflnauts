--- Generates clouds over time with randomized positions and styles.
-- Also used as factory for Clouds.
CloudGenerator = require "not.Object":extends()

require "not.Cloud"

function CloudGenerator:new (atlas, animations, count, world)
	self.world = world
	self.atlas = atlas
	self.quads = animations
	self.count = count
	self.interval = 6
	self.timer = 0
end

-- TODO: This was a bad idea. Move Cloud creation back to World, pass created Cloud here for configuration.
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
	count = count or 1
	for i=1,count do
		local x, y = self:getRandomPosition(inside)
		local style = self:getRandomStyle()
		self.world:insertCloud(self:createCloud(x, y, style))
	end
end

function CloudGenerator:update (dt)
	local count = self.world:getCloudsCount()
	if self.timer < 0 and self.count > count then
		self.timer = self.timer + self.interval
		self:run()
	else
		self.timer = self.timer - dt
	end
end

return CloudGenerator
