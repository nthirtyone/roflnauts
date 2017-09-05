--- Generates clouds over time with randomized positions and styles.
-- Also used as factory for Clouds.
CloudGenerator = require "not.Object":extends()

require "not.Cloud"

-- TODO: Allow map config to modify cloud styles.
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

function CloudGenerator:new (world)
	self.world = world
	self.atlas = "assets/clouds.png"
	self.quads = animations
end

function CloudGenerator:createCloud (x, y)
	local cloud = Cloud(x, y, self.world, self.atlas)
	cloud:setAnimationsList(self.quads)
	cloud:setVelocity(13, 0)
	cloud:setBoundary(340, 320)
	return cloud
end

function CloudGenerator:randomize (outside)
	if outside == nil then
		outside = true
	else
		outside = outside
	end
	local x,y,t,v
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

function CloudGenerator:update (dt)
	local count = self.world:getCloudsCount()
end

return CloudGenerator
