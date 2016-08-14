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
function Selector:setPosition(x,y)
	self.x = x
	self.y = y
end
function Selector:getPosition()
	return self.x, self.y
end
function Selector:assignController(controller)
	controller:setParent(self)
	self.controller = controller
	self.naut = 2
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

-- LÖVE2D callbacks
function Selector:draw()
	-- portrait, sprite
	local name = self.parent.nauts[self.naut]
	local p = self.parent.portrait_sheet[name]
	local sprite = self.parent.portrait_sprite
	-- scale, position
	local scale = self.parent.scale
	local x,y = self:getPosition()
	-- arrows
	local arrowl = self.parent.portrait_sheet.arrow_left
	local arrowr = self.parent.portrait_sheet.arrow_right
	if not self.state then
		love.graphics.draw(sprite, p.normal, x*scale, y*scale, 0, scale, scale)
		if self.controller ~= nil then
			love.graphics.draw(sprite, arrowl, (x-2)* scale, (y+13)*scale, 0, scale, scale)
			love.graphics.draw(sprite, arrowr, (x+30)*scale, (y+13)*scale, 0, scale, scale)
		end
	else
		love.graphics.draw(sprite, p.active, x*scale, y*scale, 0, scale, scale)
	end
	if self.naut ~= 1 then
		love.graphics.printf(string.upper(name), (x-8)*scale, (y+33)*scale, 48, "center", 0, scale, scale)
	end
end

-- Controller callbacks
function Selector:controlpressed(set, action, key)
	local n = #self.parent.nauts
	if control == "left" and not self.state then
		if self.naut == 2 or self.naut == 1 then
			self.naut = n
		else
			self.naut = self.naut - 1
		end
	elseif control == "right" and not self.state then
		if self.naut == n then
			self.naut = 2
		else
			self.naut = self.naut + 1
		end
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
function Selector:controlreleased(set, action, key)
end