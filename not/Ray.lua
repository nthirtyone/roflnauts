--- That awesome effect that blinks when player dies!
Ray = require "not.Object":extends()

function Ray:new (source, world)
	self.source = source
	self.world = world
	self.delay = 1.2
end

function Ray:update (dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		return true -- delete
	end
	return false
end

-- TODO: Ray is work-in-progress.
-- TODO: Whole Ray is dated but `draw` require a lot attention due to layering in World. See `World@new`.
function Ray:draw ()
	love.graphics.setColor(255, 247, 228, 247)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(self.delay*160)

	local x, y = self.source:getPosition()
	local m = self.world.map
	local dy = m.height

	if y > m.center.y then
		dy = -dy
	end

	local offset_x, offset_y = 0, 0

	-- love.graphics.rectangle("fill", 0, 0, 200, 200)

	love.graphics.line(-x+offset_x,-y+offset_y-dy*0.7,x+offset_x,y+dy*0.7+offset_y)
end

return Ray
