--- `Decoration`
-- Positioned sprite used to decorate maps with additional graphics.
Decoration = {
	world = --[[not.World]]nil,
	x = 0,
	y = 0
}

-- `Decoration` is a child of `Sprite`.
require "not.Sprite"
Decoration.__index = Decoration
setmetatable(Decoration, Sprite)

-- Constructor of `Decoration`.
function Decoration:new (x, y, imagePath)
	local o = setmetatable({}, self)
	o:init(x, y, imagePath)
	return o
end

-- Initializer of `Decoration`.
function Decoration:init (x, y, imagePath)
	Sprite.init(self, imagePath)
	self:setPosition(x, y)
end

-- Position-related methods.
function Decoration:getPosition ()
	return self.x, self.y
end
function Decoration:setPosition (x, y)
	self.x, self.y = x, y
end