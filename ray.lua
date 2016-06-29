-- `Ray`
-- That awesome effect that blinks when player dies!

-- WHOLE CODE HAS FLAG OF "need a cleanup"

Ray = {
	naut = nil,
	world = nil,
	canvas = nil,
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
	-- Cavas, this is temporary, I believe.
	local scale = o.world.camera.scale
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	o.canvas = love.graphics.newCanvas(w/scale, h/scale)
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
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	love.graphics.setColor(255, 247, 228, 247)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(self.delay*160)
	local x, y = self.naut:getPosition()
	local m = self.world.map
	local dy = m.height
	if y > m.center_y then
		dy = -dy
	end
	love.graphics.line(-x+offset_x,-y+offset_y-dy*0.7,x+offset_x,y+dy*0.7+offset_y)
	-- reset
	love.graphics.setCanvas()
	love.graphics.setLineWidth(1)
	love.graphics.setColor(255,255,255,255)
	-- draw on screen
	love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
end
