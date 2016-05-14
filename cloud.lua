-- `Cloud`
-- That white thing moving in the background.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `Cloud`
Cloud = {
	x = 0,
	y = 0,
	sprite = love.graphics.newImage("assets/clouds.png")
}

-- Constructor of `Cloud`
function Cloud:new()
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Misc
	return o
end