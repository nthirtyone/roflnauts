-- `Selector`
-- Used in menu; selecting nauts?
Selector = {
	naut = 1,
	x = 0,
	y = 0,
	parent = nil,
	controlset = nil,
	locked = false
}
function Selector:new(menu)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = menu
	return o
end
-- Position
function Selector:setPosition(x,y)
	self.x = x
	self.y = y
end
function Selector:getPosition()
	return self.x, self.y
end
-- Control Sets
function Selector:assignControlSet(set)
	self.controlset = set
	self.naut = 2
end
function Selector:getControlSet()
	if self.controlset ~= nil then
		return self.controlset
	end
end
-- States
function Selector:getState()
	if self:getControlSet() ~= nil then
		if self.locked then
			return 2 -- has controls and locked
		end
		return 1 -- has controls but not locked
	end
	return 0 -- no controls and not locked
end
function Selector:clear()
	self.controlset = nil
	self.naut = 1
	self.locked = 0
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
	if not self.locked then
		love.graphics.draw(sprite, p.normal, x*scale, y*scale, 0, scale, scale)
		if self.controlset ~= nil then
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
	-- locals
	local n = #self.parent.nauts
	if set == self:getControlSet() then
		if action == "left" and not self.locked then
			if self.naut == 2 or self.naut == 1 then
				self.naut = n
			else
				self.naut = self.naut - 1
			end
		elseif action == "right" and not self.locked then
			if self.naut == n then
				self.naut = 2
			else
				self.naut = self.naut + 1
			end
		elseif action == "attack" then
			if self.naut ~= 1 then
				self.locked = true
			end
		elseif action == "jump" then
			if self.locked == true then
				self.locked = false
			else
				self.parent:unselectSelector(self)
			end
		end
	end
end
function Selector:controlreleased(set, action, key)
end