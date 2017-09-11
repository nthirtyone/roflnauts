require "not.Entity"

--- `Decoration`
-- Positioned sprite used to decorate maps with additional graphics.
Decoration = Entity:extends()

Decoration.x = 0
Decoration.y = 0

-- Constructor of `Decoration`.
function Decoration:new (x, y, world, imagePath)
	Decoration.__super.new(self, world, imagePath)
	self:setPosition(x, y)
end

-- Position-related methods.
function Decoration:getPosition ()
	return self.x, self.y
end
function Decoration:setPosition (x, y)
	self.x, self.y = x, y
end

return Decoration
