require "not.Object"

--- `Ray`
-- That awesome effect that blinks when player dies!
Ray = Object:extends()

Ray.naut =--[[not.Hero]]nil
Ray.world =--[[not.World]]nil
Ray.canvas =--[[love.graphics.newCanvas]]nil
Ray.delay = 0.3

function Ray:new (naut, world)
	self.naut = naut
	self.world = world
	-- Cavas, this is temporary, I believe.
	local scale = getScale()
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	self.canvas = love.graphics.newCanvas(w/scale, h/scale)
end

function Ray:update (dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		return true -- delete
	end
	return false
end

function Ray:draw (offset_x, offset_y, scale)
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

return Ray
