-- `Menu`
-- It is one of the last things I will need to mess around with. I'm happy and surprised everything works so far.
-- For sure I have learnt a lot about lua during this journey. Still a lot ahead. I will continue writing in the same style though, to not make it even worse.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "selector"

-- Metatable of `Menu`
Menu = {
	logo = nil,
	-- move selectors to one table; make functions to retrieve selectors w or w/o controller
	selectors = nil,
	selected = nil,
	nauts = require "nautslist",
	portrait_sprite = nil,
	portrait_sheet  = require "portraits",
	scale = 4,
	countdown = 6
}

-- Constructor of `Menu`
function Menu:new ()
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- initialize
	o.logo = nil
	o.selectors = {}
	o.selected  = {}
	o.portrait_sprite = love.graphics.newImage("assets/portraits.png")
	return o
end

-- Naut selector
function Menu:newSelector()
	local selector = Selector:new(self)
	local w, h = love.graphics.getWidth()/self.scale, love.graphics.getHeight()/self.scale
	local n = #self.selectors - 1
	table.insert(self.selectors, selector)
	local x = (w-76)/2+n*44
	local y = h/2-16
	selector:setPosition(x, y)
end

--
function Menu:draw()
	for _,selector in pairs(self.selectors) do
		selector:draw()
	end
	for _,selector in pairs(self.selected) do
		selector:draw()
	end
	local countdown, _ = math.modf(self.countdown)
	local w, h = love.graphics.getWidth()/self.scale, love.graphics.getHeight()/self.scale
	if self.countdown < 6 then
		love.graphics.setFont(Bold)
		love.graphics.print(countdown,(w/2-6.5)*self.scale,(h/2+20)*self.scale,0,2,2)
		love.graphics.setFont(Font)
	end
end

function Menu:update(dt)
	local state = true
	if #self.selected > 1 then
		for _,selector in pairs(self.selected) do
			state = state and selector.state
		end
	else
		state = false
	end
	if state then
		self.countdown = self.countdown - dt
	else
		self.countdown = 6
	end
	if state and self.countdown < 0 then
		self:startGame()
	end
end

--
function Menu:unselectSelector(selector)
	local i = 0
	for _,v in pairs(self.selected) do
		if v == selector then
			i = _
			break
		end
	end
	if i ~= 0 then
		table.remove(self.selected, i)
		table.insert(self.selectors, selector)
		self:assignController(selector:getController())
		selector:clear()
	end
end

-- Controllers
function Menu:assignController(controller)
	controller:setParent(self)
end

function Menu:controllerPressed(control, controller)
	local selector = self.selectors[1]
	if selector ~= nil then
		table.remove(self.selectors, 1)
		table.insert(self.selected, selector)
		selector:assignController(controller)
		selector:controllerPressed(control)
	end
end

-- It just must be here
function Menu:controllerReleased(control, controller)
end

function Menu:getNauts()
	local nauts = {}
	for _,selector in pairs(self.selected) do
		table.insert(nauts, {selector:getSelectionName(), selector:getController()})
	end
	return nauts
end

-- WARUDO
function Menu:startGame()
	local world = World:new("default", self:getNauts())
	changeScene(world)
end