--- That awesome effect that blinks when player dies!
Ray = require "not.Object":extends()

function Ray:new (source, world)
	self.source = source
	self.world = world
	self.delay = 0.3
end

function Ray:update (dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		return true -- delete
	end
	return false
end

-- TODO: Ray should use Camera boundaries just-in-case.
-- TODO: Ray uses magic numbers.
function Ray:draw ()
	love.graphics.setColor(1, .97, .89, .97)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(self.delay*160)

	local x, y = self.source:getPosition()

	love.graphics.line(x, y, -x, -y)
end

return Ray
