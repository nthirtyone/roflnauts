--- Element used for grouping elements and passing input to selected child based on controller set.
Group = require "not.Element":extends()

function Group:new (parent)
	Group.__super.new(self, parent)
	self.children = {}
	self.margin = 0
end

function Group:addChild (element)
	table.insert(self.children, element)
	return element
end

-- TODO: Missing semi-important docs on Group's setPosition.
function Group:setPosition (x, y)
	local dx = 0
	for _,child in ipairs(self.children) do
		child:setPosition(x + dx, y)
		dx = dx + child:getSize() + self.margin
	end
	return Group.__super.setPosition(self, x, y)
end

function Group:getSize ()
	local twidth = -self.margin
	local theight = 0
	for _,child in ipairs(self.children) do
		local cwidth, cheight = child:getSize()
		twidth = twidth + child:getSize() + self.margin
		if theight < cheight then
			theight = cheight
		end
	end
	return twidth, theight
end

--- Calls function with parameters for each child.
-- @param func key of function to call
-- @param ... parameters passed to function
-- @return table with calls' results
function Group:callEach (func, ...)
	local results = {}
	for _,child in ipairs(self.children) do
		if type(child[func]) == "function" then
			table.insert(results, child[func](child, ...) or nil)
		end
	end
	return results
end

--- Calls function with parameters for each but one child.
-- @param avoid child to avoid calling
-- @param func key of function to call
-- @param ... parameters passed to function
-- @return table with calls' results
function Group:callEachBut (avoid, func, ...)
	local results = {}
	for _,child in ipairs(self.children) do
		if child ~= avoid then
			if type(child[func]) == "function" then
				table.insert(results, child[func](child, ...) or nil)
			end
		end
	end
	return results
end

--- Calls function with parameters for one child based on controller set.
-- @param set controller set
-- @param func key of function to call
-- @param ... parameters passed to function
-- @return results of called function
function Group:callWithSet (set, func, ...)
	for i,test in ipairs(Controller.getSets()) do
		if test == set then
			local child = self.children[i]
			if child then
				return child[func](child, ...)
			end
		end
	end
end

function Group:focus ()
	self:callEach("focus")
	self.focused = true
	return true
end 

function Group:blur ()
	self:callEach("blur")
	self.focused = false
end 

function Group:draw (scale)
	self:callEach("draw", scale)
end

function Group:update (dt)
	self:callEach("update", dt)
end

function Group:controlpressed (set, action, key)
	if self.focused then
		self:callWithSet(set, "controlpressed", set, action, key)
	end
end

function Group:controlreleased (set, action, key)
	if self.focused then
		self:callWithSet(set, "controlreleased", set, action, key)
	end
end

return Group
