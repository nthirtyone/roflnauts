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
end

function CloudGenerator:createCloud (x, y, style)
	local cloud = Cloud(x, y, self.world, self.atlas)
	cloud:setAnimationsList(self.quads)
	cloud:setAnimation(style)
	cloud:setVelocity(13, 0)
	cloud:setBoundary(340, 320)
	return cloud
end

function CloudGenerator:getRandomPosition (inside)
	return 20, 20
end

function CloudGenerator:getRandomStyle ()
	return "default"
end

--[[
function CloudGenerator:randomize (outside)
	local m = self.map
	if outside then
		x = m.center.x-m.width*1.2+love.math.random(-50,20)
	else
		x = love.math.random(m.center.x-m.width/2,m.center.x+m.width/2)
	end
	y = love.math.random(m.center.y-m.height/2, m.center.y+m.height/2)
	t = love.math.random(1,3)
	v = love.math.random(8,18)
end
]]

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
	self:run()
end

return CloudGenerator
