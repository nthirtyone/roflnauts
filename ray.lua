-- `Ray`
-- That awesome effect that blinks when player dies!

-- WHOLE CODE HAS FLAG OF "need a cleanup"

Ray = {
	naut = nil,
	world = nil,
	delay = 0.3
}
function Ray:new(naut, world)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Init
	o.naut = naut
	o.world = world
	return o
end
function Ray:update(dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		return true -- delete
	end
	return false
end
function Ray:draw(offset_x, offset_y, scale)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(self.delay*160*scale)
	local x, y = self.naut:getPosition()
	local m = self.world.map
	local dy = m.height
	if y > m.center_y then
		dy = -dy
	end
	local dx = m.width
	if x > m.center_x then
		dx = -dx
	end
	love.graphics.line((m.center_x+offset_x+dx)*scale,(m.center_y+offset_y+dy)*scale,(x+offset_x)*scale,(y+dy*0.7+offset_y)*scale)
	love.graphics.setLineWidth(1)
end
