-- `Cloud`
-- That white thing moving in the background. 

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `Cloud`
Cloud = {
	x = 0,
	y = 0,
	t = 1, -- Type of the cloud (quad number)
	sprite = love.graphics.newImage("assets/clouds.png"),
	quads = {
		[1] = love.graphics.newQuad(  1,159, 158,47, 480,49),
		[2] = love.graphics.newQuad(161,319, 158,47, 480,49),
		[3] = love.graphics.newQuad(321,479, 158,47, 480,49)
	}
}

-- Constructor of `Cloud`
function Cloud:new(x, y, t)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Init
	o.x = x or self.x
	o.y = y or self.y
	o.t = t or self.t
	return o
end

-- Update of `Cloud`, returns x for world to delete cloud after reaching right corner
function Cloud:update(dt)
	return x
end

-- Draw `Cloud`
function Cloud:draw()
end