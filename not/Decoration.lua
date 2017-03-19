-- TODO: follow new code template
-- TODO: add comments
require "not.Sprite"
Decoration = {
	world = nil,
	sprite = nil,
	x = 0,
	y = 0
}
Decoration.__index = Decoration
setmetatable(Decoration, Sprite)
function Decoration:new(x, y, sprite)
	local o = {}
	setmetatable(o, self)
	o:setImage(love.graphics.newImage(sprite))
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
	Sprite.draw(self, offset_x, offset_y, scale)
end