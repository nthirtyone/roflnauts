-- `Cloud`
-- That white thing moving in the background. 

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `Cloud`
-- nils initialized in constructor
-- TODO: inherit from `not.Decoration` or `not.Sprite`, depending on final result of `not.Sprite`.
Cloud = {
	x = 0,  -- position horizontal
	y = 0,  -- position vertical
	t = 1,  -- type (sprite number)
	v = 13, -- velocity
	sprite = nil,
	quads = {
		[1] = love.graphics.newQuad(  1,  1, 158,47, 478,49),
		[2] = love.graphics.newQuad(160,  1, 158,47, 478,49),
		[3] = love.graphics.newQuad(319,  1, 158,47, 478,49)
	}
}

-- Constructor of `Cloud`
function Cloud:new(x, y, t, v)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Load spritesheet to metatable if not yet loaded
	if self.sprite == nil then
		self.sprite = love.graphics.newImage("assets/clouds.png")
	end
	-- Init
	o.x = x or self.x
	o.y = y or self.y
	o.t = t or self.t
	o.v = v or self.v
	return o
end

-- Position
function Cloud:getPosition()
	return self.x, self.y
end

-- Update of `Cloud`, returns x for world to delete cloud after reaching right corner
function Cloud:update(dt)
	self.x = self.x + self.v*dt
	return self.x
end

-- Draw `Cloud`
function Cloud:draw(offset_x, offset_y, scale)
	-- locals
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	local scale = scale or 1
	local x, y = self:getPosition()
	-- pixel grid
	local draw_x = (math.floor(x) + offset_x) * scale
	local draw_y = (math.floor(y) + offset_y) * scale
	-- draw
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.sprite, self.quads[self.t], draw_x, draw_y, 0, scale, scale)
end