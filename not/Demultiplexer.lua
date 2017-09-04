--- Element used for grouping elements and demultiplexing input of different controller sets.
Demultiplexer = require "not.Element":extends()

function Demultiplexer:new (parent)
	Demultiplexer.__super.new(self, parent)
	self.children = {}
end

--- Calls function with parameters for each child.
-- @param func key of function to call
-- @param ... parameters passed to function
-- @return table with calls' results
function Demultiplexer:callEach (func, ...)
	local results = {}
	for _,child in ipairs(self.children) do
		if type(child[func]) == "function" then
			table.insert(results, child[func](child, ...))
		end
	end
	return results
end

--- Calls function with parameters for one child based on controller set.
-- @param set controller set
-- @param func key of function to call
-- @param ... parameters passed to function
function Demultiplexer:callWithSet (set, func, ...)
	for i,test in ipairs(Controller.getSets()) do
		if test == set then
			local child = self.children[i]
			if child then
				return child[func](child, ...)
			end
		end
	end
end

function Demultiplexer:focus ()
	self:callEach("focus")
	self.focused = true
	return true
end 

function Demultiplexer:blur ()
	self:callEach("blur")
	self.focused = false
end 

function Demultiplexer:draw (scale)
	self:callEach("draw", scale)
end

function Demultiplexer:update (dt)
	self:callEach("update", dt)
end

function Demultiplexer:controlpressed (set, action, key)
	if self.focused then
		self:callWithSet(set, "controlpressed", set, action, key)
	end
end

function Demultiplexer:controlreleased (set, action, key)
	if self.focused then
		self:callWithSet(set, "controlreleased", set, action, key)
	end
end

return Demultiplexer
