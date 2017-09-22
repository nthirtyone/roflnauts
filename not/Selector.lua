--- `Selector`
-- Element for selecting variable from list.
Selector = require "not.Element":extends()

Selector.DEFAULT_DELAY = 2
Selector.SHAPE_PORTRAIT = 1
Selector.SHAPE_PANORAMA = 2

function Selector:new (list, group, parent)
	Selector.__super.new(self, parent)
	self.atlas, self.quads = parent:getSheet()
	self.group = group
	self.list = list
	self.delay = Selector.DEFAULT_DELAY
	self.shape = Selector.SHAPE_PORTRAIT
	self.focused = false
	self.lock = false
	self.index = 1
end

-- TODO: See `not/Element@getSize`.
function Selector:getSize ()
	if self.shape == Selector.SHAPE_PORTRAIT then
		return 32, 32
	end
	if self.shape == Selector.SHAPE_PANORAMA then
		return 80, 42
	end
end

--- Makes sure that n is in <1, total> range.
local
function limit (n, total)
	if n > total then
		return limit(n - total, total)
	end
	if n < 1 then
		return limit(n + total, total)
	end
	return n
end

--- Chooses item with an index.
-- @param index selected item's index
-- @return old index
function Selector:setIndex (index)
	local old = self.index
	self.index = limit(index, #self.list)
	return old
end

function Selector:rollRandom (exclude)
	local exclude = exclude or {}
	local index = love.math.random(1, #self.list)
	local elgible = true
	for _,i in ipairs(exclude) do
		if index == i then
			elgible = false
			break
		end
	end
	if not elgible or not self:isUnique(self.list[index]) then
		table.insert(exclude, index)
		return self:rollRandom(exclude)
	end
	return index
end

--- Returns selected item's value.
-- @return item selected from the list
function Selector:getSelected ()
	return self.list[self.index]
end

--- Checks if selection is locked and returns item's value.
-- @return item selected from the list if Selector is locked, nil otherwise
function Selector:getLocked ()
	if self.lock then
		return self:getSelected()
	end
end

--- Checks if Selected value is unique in group's scope.
-- @param index optional parameter to fill in place of currently selected item
-- @return boolean answering question
function Selector:isUnique (item)
	local item = item or self:getSelected()
	if self.group then
		local locked = self.group:callEachBut(self, "getLocked")
		for _,value in pairs(locked) do
			if value == item then
				return false
			end
		end
	end
	return true
end

function Selector:getText ()
	return tostring(self:getSelected())
end

function Selector:getIcon ()
	if self.icons then
		return self.icons[self.index]
	end
end

function Selector:focus ()
	self.focused = true
	return true
end

function Selector:blur ()
	self.focused = false
end

-- TODO: Temporary function to determine quad to use. Will be obsolete when BoxElement will be done. See also `not/Element@getSize`.
function Selector:getShapeString ()
	if self.shape == Selector.SHAPE_PORTRAIT then
		return "portrait"
	end
	if self.shape == Selector.SHAPE_PANORAMA then
		return "panorama"
	end
end

function Selector:draw (scale)
	local x, y = self:getPosition()
	local w, h = self:getSize()

	local boxType = "normal"
	if self:getLocked() then
		boxType = "active"
	end

	love.graphics.setColor(255, 255, 255, 255)
	if not self:isUnique() then
		love.graphics.setColor(120, 120, 120, 255)
	end
	love.graphics.draw(self.atlas, self.quads[self:getShapeString()][boxType], x*scale, y*scale, 0, scale, scale)
	-- TODO: That is one way to draw icon for selected value. Find better one. See: `config/menus/host`.
	local icon = self:getIcon()
	if icon then
		love.graphics.draw(icon, (x+2)*scale, (y+3)*scale, 0, scale, scale)
	end

	love.graphics.setColor(255, 255, 255, 255)

	if self.focused then
		local dy = (h-6)/2
		local al, ar = self.quads.arrow_r, self.quads.arrow_l
		if self.lock then
			al, ar = ar, al
		end

		love.graphics.draw(self.atlas, ar, (x+0-2-math.floor(self.delay))*scale, (y+dy)*scale, 0, scale, scale)
		love.graphics.draw(self.atlas, al, (x+w-4+math.floor(self.delay))*scale, (y+dy)*scale, 0, scale, scale)
	end

	love.graphics.setFont(Font)
	love.graphics.printf(self:getText(), (x-w)*scale, (y+h+1)*scale, w*3, "center", 0, scale, scale)
end

function Selector:update (dt)
	self.delay = self.delay + dt
	if self.delay > Selector.DEFAULT_DELAY then
		self.delay = self.delay - Selector.DEFAULT_DELAY
	end
end

function Selector:controlpressed (set, action, key)
	if set and self.focused then
		local handler = self[action]
		if handler then
			handler(self)
		end
	end
end

function Selector:left ()
	if not self.lock then
		self:setIndex(self.index - 1)
	end
end

function Selector:right ()
	if not self.lock then
		self:setIndex(self.index + 1)
	end
end

function Selector:attack ()
	self.lock = true
end

-- Selector doesn't actually jump, haha, I tricked you!
function Selector:jump ()
	self.lock = false
end

return Selector
