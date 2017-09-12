--- A little bit more than just a Canvas.
Layer = require "not.Object":extends()

function Layer:new (width, height)
	self.canvas = love.graphics.newCanvas(width, height)
	self.scale = false
	self.ratio = false
end

function Layer:delete ()
	self.canvas = nil
end

--- Sets this layer as current canvas for drawing with love.graphics functions.
-- @return old canvas used by love
function Layer:setAsCanvas ()
	local c = love.graphics.getCanvas()
	love.graphics.setCanvas(self.canvas)
	return c
end

function Layer:renderTo (func, ...)
	local c = self:setAsCanvas()
	func(...)
	love.graphics.setCanvas(c)
end

function Layer:renderToWith (camera, func, ...)
	camera:push()
	camera:scale(self.scale)
	camera:translate(self.ratio)
	self:renderTo(func, ...)
	camera:pop()
end

function Layer:clear ()
	self:renderTo(love.graphics.clear)
end

function Layer:draw ()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas)
end

return Layer
