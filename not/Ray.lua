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

-- TODO: For some reason ray needs these 50s on camera boundaries.
-- TODO: Ray draw should be cleaned-up and exploded into methods if possible.
function Ray:draw ()
	love.graphics.setColor(255, 247, 228, 247)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(self.delay*160)

	-- point b top-left
	-- point c bottom-right
	-- point d ray start
	-- point e ray end

	local x, y = self.source:getPosition()
	local bx, by, cx, cy = self.world.camera:getBoundaries()
	local a = y / x

	bx = bx - 50
	by = by - 50
	cx = cx + 50
	cy = cy + 50

	local dy, dx = bx * a, bx
	if dy < by or dy > cy then
		dy = by
		dx = by / a
	end

	local ey, ex = cx * a, cx
	if ey < by or ey > cy then
		ey = cy
		ex = cy / a
	end

	love.graphics.line(dx, dy, ex, ey)
end

return Ray
