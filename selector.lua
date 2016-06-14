-- `Selector`
-- Used in menu; selecting nauts?
Selector = {
	naut = 1,
	x = 0,
	y = 0,
	parent = nil,
	controller = nil,
	state = false
}
function Selector:new(menu)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = menu
	return o
end
function Selector:setPosition (x,y)
	self.x = x
	self.y = y
end
function Selector:getPosition ()
	return self.x, self.y
end
function Selector:draw ()
	-- portrait, sprite
	local p = self.parent.portrait_sheet[self.parent.nauts[self.naut]]
	local sprite = self.parent.portrait_sprite
	-- scale, position
	local scale = self.parent.scale
	local x,y = self:getPosition()
	-- arrows
	local arrowl = self.parent.portrait_sheet.arrow_left
	local arrowr = self.parent.portrait_sheet.arrow_right
	if not self.state then
		love.graphics.draw(sprite, p.normal, x*scale, y*scale, 0, 1*scale, 1*scale)
		if self.controller ~= nil then
			love.graphics.draw(sprite, arrowl, (x-2)* scale, (y+13)*scale, 0, scale, scale)
			love.graphics.draw(sprite, arrowr, (x+30)*scale, (y+13)*scale, 0, scale, scale)
		end
	else
		love.graphics.draw(sprite, p.active, x*scale, y*scale, 0, 1*scale, 1*scale)
	end
end
function Selector:assignController(controller)
	controller:setParent(self)
	self.controller = controller
end
function Selector:getController()
	if self.controller ~= nil then
		return self.controller
	end
end
function Selector:clear()
	self.controller = nil
	self.naut = 1
	self.state = false
end
function Selector:getSelectionName()
	return self.parent.nauts[self.naut]
end
function Selector:controllerPressed(control, controller)
	local n = #self.parent.nauts
	if control == "left" and not self.state then
		if self.naut == 1 then
			self.naut = n
		else
			self.naut = self.naut - 1
		end
	elseif control == "right" and not self.state then
		self.naut = (self.naut % n) + 1
	elseif control == "attack" then
		if self.naut ~= 1 then
			self.state = true
		end
	elseif control == "jump" then
		if self.state == true then
			self.state = false
		else
			self.parent:unselectSelector(self)
		end
	end
end
-- It just must be here
function Selector:controllerReleased(control, controller)
end