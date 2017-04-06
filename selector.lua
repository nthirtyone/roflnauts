-- `Selector` (Element)
-- Used in Menu for selecting various things from list. Works for each Controller set or globally.
--[[
How to use `Selector` in `Menu` config file?
selector:new(menu)
	:setPosition(x, y)
	:setMargin(8) -- each block has marigin on both sides; they do stack
	:setSize(32, 32) -- size of single graphics frame
	:set("list", require "nautslist")
	:set("icons_i", love.graphics.newImage("assets/portraits.png"))
	:set("icons_q", require "portraits")
	:set("global", false) -- true: single selector; false: selector for each controller set present
	:init()
]]

Selector = {
	parent,
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	margin = 0,
	focused = false,
	global = false,
	delay = 2,
	first = false,
	list,
	sets,
	locks,
	selections,
	shape = "portrait",
	sprite,
	quads,
	icons_i,
	icons_q
}

-- Constructor
function Selector:new(parent)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.parent = parent
	o.sprite, o.quads = parent:getSheet()
	return o
end

-- Position
function Selector:getPosition()
	return self.x, self.y
end
function Selector:setPosition(x,y)
	self.x, self.y = x, y
	return self
end

-- Size of single block
function Selector:getSize()
	return self.width, self.height
end
function Selector:setSize(width, height)
	self.width, self.height = width, height
	return self
end

-- Spacing between two blocks
function Selector:getMargin()
	return self.margin
end
function Selector:setMargin(margin)
	self.margin = margin
	return self
end

-- General setter for Menu configuration files
function Selector:set(name, func)
	if type(name) == "string" and func ~= nil then
		self[name] = func
	end
	return self
end

-- Initialize Selector with current settings.
function Selector:init()
	-- Make sure that there is list present
	if self.list == nil then
		self.list = {}
	end
	-- Initialize global Selector
	if self.global then
		self.sets = {}
		self.locks = {false}
		self.selections = {1}
	-- Initialize Selector for Controllers
	else
		self.sets = Controller.getSets()
		self.locks = {}
		self.selections = {}
		for n=1,#self.sets do
			self.locks[n] = false
			self.selections[n] = 1
		end
	end
	return self
end

-- Cycle through list on given number
function Selector:next(n)
	local current = self.selections[n]
	self:setSelection(n, current + 1)
end
function Selector:previous(n)
	local current = self.selections[n]
	self:setSelection(n, current - 1)
end

-- Get number associated with a given set
function Selector:checkNumber(set)
	if self.global then return 1 end -- For global Selector
	for n,check in pairs(self.sets) do
		if check == set then return n end
	end
end

-- Check if given number is locked
function Selector:isLocked(n)
	local n = n or 1
	return self.locks[n]
end

-- Sets value of selection of given number. Returns old.
function Selector:setSelection(n, new)
	-- Functception. It sounds like fun but it isn't.
	local function limit(new, total)
		if new > total then
			return limit(new - total, total)
		elseif new < 1 then
			return limit(total + new, total)
		else 
			return new
		end
	end
	local n = n or 1
	local old = self.selections[n]
	self.selections[n] = limit(new, #self.list)
	return old
end

-- Get value of selection of given number
function Selector:getSelection(n)
	local n = n or 1
	return self.selections[n]
end

-- Get value from list by selection
function Selector:getListValue(i)
	return self.list[i]
end

-- Checks if selection of given number is unique within Selector scope.
function Selector:isUnique(n)
	local selection = self:getSelection(n)
	for fn,v in pairs(self.selections) do
		if fn ~= n and self:isLocked(fn) and v == selection then
			return false
		end
	end
	return true
end

-- Get list of selections, checks if not locked are allowed.
function Selector:getFullSelection(allowed)
	local allowed = allowed
	if allowed == nil then allowed = false end
	local t = {}
	for n,v in pairs(self.selections) do
		local name = self:getListValue(self:getSelection(n))
		local locked = self:isLocked(n)
		if locked or allowed then
			local a = {name}
			if self.sets[n] then table.insert(a, self.sets[n]) end
			table.insert(t, a)
		end
	end
	return t
end

-- Rolls and returns random selection from list that is not locked.
function Selector:rollRandom(avoids)
	-- Me: You should make it simpler.
	-- Inner me: Nah, it works. Leave it.
	-- Me: Ok, let's leave it as it is.
	local avoids = avoids or {}
	local total = #self.list
	local random = love.math.random(1, total)
	local eligible = true
	for _,avoid in ipairs(avoids) do
		if random == avoid then
			eligible = false
			break
		end
	end
	if not eligible or self:isLocked(random) then
		table.insert(avoids, random)
		return self:rollRandom(avoid)
	else
		return random
	end
end

-- Draw single block of Selector
function Selector:drawBlock(n, x, y, scale)
	if self.quads == nil or self.sprite == nil then return end
	local x, y = x or 0, y or 0
	local name = self:getListValue(self:getSelection(n))
	local locked = self:isLocked(n)
	local sprite = self.sprite
	local quad = self.quads
	local icon  = self.icons_i
	local iconq = self.icons_q[name]
	local w,h = self:getSize()
	local unique = self:isUnique(n)
	if unique then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(140, 140, 140, 255)
	end
	if not locked then
		love.graphics.draw(sprite, quad[self.shape].normal, x*scale, y*scale, 0, scale, scale)
	else
		love.graphics.draw(sprite, quad[self.shape].active, x*scale, y*scale, 0, scale, scale)
	end
	love.graphics.draw(icon, iconq, (x+2)*scale, (y+3)*scale, 0, scale, scale)
	if self.focused then
		local dy = (h-6)/2
		if not locked then
			love.graphics.draw(sprite, quad.arrow_l, (x+0-2-math.floor(self.delay))* scale, (y+dy)*scale, 0, scale, scale)
			love.graphics.draw(sprite, quad.arrow_r, (x+w-4+math.floor(self.delay))*scale, (y+dy)*scale, 0, scale, scale)
		else
			love.graphics.draw(sprite, quad.arrow_r, (x+0-2-math.floor(self.delay))* scale, (y+dy)*scale, 0, scale, scale)
			love.graphics.draw(sprite, quad.arrow_l, (x+w-4+math.floor(self.delay))*scale, (y+dy)*scale, 0, scale, scale)
		end
	end
	if (self:getSelection(n) ~= 1 or self.first) then
		love.graphics.setFont(Font)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf(string.upper(name), (x-w)*scale, (y+h+1)*scale, w*3, "center", 0, scale, scale)
	end
end

-- Menu callbacks
function Selector:focus() -- Called when Element gains focus
	self.focused = true
	return true
end 
function Selector:blur() -- Called when Element loses focus
	self.focused = false
end 

-- LÖVE2D callbacks
function Selector:draw(scale)
	local x,y = self:getPosition()
	local margin = self:getMargin()
	local width = self:getSize()
	x = x - #self.selections*0.5*(margin+margin+width)
	for n=1,#self.selections do
		self:drawBlock(n, x+(margin+width)*(n-1)+margin*n, y, scale)
	end
end
function Selector:update(dt)
	self.delay = self.delay + dt
	if self.delay > Selector.delay then -- Selector.delay is initial
		self.delay = self.delay - Selector.delay
	end
end

-- Controller callbacks
-- TODO: Add action to perform when key is pressed and selector is locked in e.g. to move into character selection from map selection.
function Selector:controlpressed(set, action, key)
	if set and self.focused then
		local n = self:checkNumber(set)
		local locked = self:isLocked(n)
		if action == "left" and not locked then self:previous(n) end
		if action == "right" and not locked then self:next(n) end
		if action == "attack" then
			local name = self:getListValue(self:getSelection(n))
			if name == "random" then
				self:setSelection(n, self:rollRandom({1,2})) -- avoid empty naut
				self.locks[n] = true
			else
				-- If not empty or if first is allowed. Additionaly must be unique selection.
				if (self:getSelection(n) ~= 1 or self.first) and self:isUnique(n) then
					self.locks[n] = true
				end
			end
		end
		if action == "jump" then
			if locked then
				self.locks[n] = false
			end
		end
	end
end
function Selector:controlreleased(set, action, key) end

return Selector