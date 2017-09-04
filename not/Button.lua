require "not.Element"

--- `Button`
-- Menu element that can be activated by user.
Button = Element:extends()

Button.text = ""
Button.focused = false
Button.sprite = --[[]]nil
Button.quads = --[[]]nil
Button.delay = 2

function Button:new (parent)
	Button.__super.new(self, parent)
	self.sprite, self.quads = parent:getSheet()
end

function Button:getSize ()
	return 58, 15
end

function Button:setText (text)
	self.text = text or ""
	return self
end

function Button:focus(next)
	self.focused = true
	return true
end
function Button:blur ()
	self.focused = false
end

function Button:active () end
function Button:isEnabled ()
	return true
end

function Button:draw (scale)
	local x,y = self:getPosition()
	local quad = self.quads
	local sprite = self.sprite
	if self:isEnabled() then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(140, 140, 140, 255)
	end
	love.graphics.draw(sprite, quad.button.normal, x*scale, y*scale, 0, scale, scale)
	if self.focused then
		love.graphics.draw(sprite, quad.arrow_l, (x+54+math.floor(self.delay))*scale, (y+5)*scale, 0, scale, scale)
		love.graphics.draw(sprite, quad.arrow_r, (x-2-math.floor(self.delay))*scale, (y+5)*scale, 0, scale, scale)
	end
	love.graphics.setFont(Font)
	love.graphics.printf(self.text, (x+2)*scale, (y+4)*scale, 54, "center", 0, scale, scale)
end

function Button:update (dt)
	self.delay = self.delay + dt
	if self.delay > Button.delay then -- Button.delay is initial
		self.delay = self.delay - Button.delay
	end
end

function Button:controlpressed (set, action, key)
	if action == "attack" and self.focused and self:isEnabled() then
		self:active()
	end
end

return Button
