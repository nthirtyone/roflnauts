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
	scale = getScale(),
	countdown = 10,
	header_move = 0
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
	-- selectors
	for i=0,3 do
		o:newSelector()
	end
	return o
end

-- Destructor
function Menu:delete()
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

function Menu:getBounce(f)
	local f = f or 1
	return math.sin(self.header_move*f*math.pi)
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
	local scale = self.scale
	if self.countdown < Menu.countdown then -- Menu.countdown is initial
		love.graphics.setFont(Bold)
		love.graphics.print(countdown,(w/2-6.5)*self.scale,(h/2+30)*self.scale,0,self.scale,self.scale)
		love.graphics.setFont(Font)
	end
	-- header
	love.graphics.setFont(Bold)
	local angle = self:getBounce(2)
	local dy = self:getBounce()*4
	love.graphics.printf("ROFLNAUTS2",(w/2)*scale,(32+dy)*scale,336,"center",(angle*5)*math.pi/180,scale,scale,168,12)
	love.graphics.setFont(Font)
	love.graphics.printf("Use W,S,A,D,G,H or Arrows,Enter,Rshift or Gamepad\n\nA game by Awesomenauts Community\nParaDoX, Burningdillo, MilkingChicken, Seltzy, Bronkey, Gnarlyman, Aki\nBased on a game by Jan Willem Nijman, Paul Veer and Bits_Beats XOXO", (w/2)*scale, (h-42)*scale, 336, "center", 0, scale, scale, 168, 4)
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
		self.countdown = Menu.countdown -- Menu.countdown is initial
	end
	if state and self.countdown < 0 then
		self:startGame()
	end
	-- Bounce header
	self.header_move = self.header_move + dt
	if self.header_move > 2 then
		self.header_move = self.header_move - 2
	end
end

-- Speed up countdown
function Menu:countdownJump()
	if self.countdown ~= Menu.countdown then -- Menu.countdown is initial
		self.countdown = self.countdown - 1
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
