--- `Selector`
-- Element for selecting variable from list.
Selector = require "not.Element":extends()

Selector.DEFAULT_DELAY = 2
Selector.SHAPE_PORTRAIT = 1
Selector.SHAPE_PANORAMA = 2

function Selector:new (group, parent)
	Selector.__super.new(self, parent)
	self.atlas, self.quads = parent:getSheet()
	self.group = group
	self.delay = Selector.DEFAULT_DELAY
	self.shape = Selector.SHAPE_PORTRAIT
	self.focused = false
	self.locked = false
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

--- Returns selected item's value.
-- @return item selected from list
function Selector:getSelected ()
	return self.list[self.index]
end

--- Checks if selection is locked and returns item's value.
-- Nil returning part is there to clarify method's behaviour.
-- @return nil if not locked, value from list if locked
function Selector:getLocked ()
	if self.locked then
		return self:getSelected()
	end
	return nil
end

--- Checks if Selected value is unique in group's scope.
function Selector:isUnique ()
	if self.group then
		-- In this case next is used to determine if table returned by call is empty.
		if next(group:callEachBut(self, "getLocked")) then
			return false
		end
	end
	return true
end

function Selector:focus ()
	self.focused = true
	return true
end

function Selector:blur ()
	self.focused = false
end

return Selector
