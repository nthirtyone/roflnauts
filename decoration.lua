Decoration = {
	world = nil,
	sprite = nil,
	x = 0,
	y = 0
}
function Decoration:new(x, y, sprite)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.sprite = love.graphics.newImage(sprite)
	o:setPosition(x,y)
	return o
end
function Decoration:setPosition(x, y)
	self.x, self.y = x, y
end
function Decoration:getPosition()
	return self.x, self.y
end
function Decoration:draw(offset_x, offset_y, scale)
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
	local x, y = self:getPosition()
	love.graphics.draw(self.sprite, draw_x, draw_y, 0, scale, scale)
end