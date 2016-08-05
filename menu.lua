-- `Menu`
-- It is one of the last things I will need to mess around with. I'm happy and surprised everything works so far.
-- For sure I have learnt a lot about lua during this journey. Still a lot ahead. I will continue writing in the same style though, to not make it even worse.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

require "selector"

-- Metatable of `Menu`
Menu = {
	-- move selectors to one table; make functions to retrieve selectors w or w/o controller
	selectors = nil,
	nauts = require "nautslist",
	portrait_sprite = nil,
	portrait_sheet  = require "portraits",
	scale = getScale(),
	countdown = 10,
	maplist = require "maplist",
	map = 1,
	header_move = 0
}

-- Constructor of `Menu`
function Menu:new ()
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- initialize
	o.selectors = {}
	o.portrait_sprite = love.graphics.newImage("assets/portraits.png")
	-- selectors
	for i=0,3 do
		o:newSelector()
	end
	-- music
	o.music = Music:new("ROFLmenu.ogg")
	return o
end

-- Destructor
function Menu:delete()
	self.music:delete()
end

-- Naut selector
function Menu:newSelector()
	local selector = Selector:new(self)
	local w, h = love.graphics.getWidth()/self.scale, love.graphics.getHeight()/self.scale
	local n = #self.selectors - 1
	table.insert(self.selectors, selector)
	local x = (w-76)/2+n*44
	local y = h/2-8
	selector:setPosition(x, y)
end

-- Selectors tables getters
-- active: with controller; inactive: without controller
function Menu:getSelectorsAll()
	return self.selectors
end
function Menu:getSelectorsActive()
	local t = {}
	for _,selector in pairs(self.selectors) do
		if selector:getController() ~= nil then
			table.insert(t, selector)
		end
	end
	return t
end
function Menu:getSelectorsInactive()
	local t = {}
	for _,selector in pairs(self.selectors) do
		if selector:getController() == nil then
			table.insert(t, selector)
		end
	end
	return t
end

-- Selectors numbers getters
function Menu:getSelectorsNumberAll()
	return #self.selectors
end
function Menu:getSelectorsNumberActive()
	local n = 0
	for _,selector in pairs(self.selectors) do
		if selector:getController() ~= nil then
			n = n + 1
		end
	end
	return n
end
function Menu:getSelectorsNumberInactive()
	local n = 0
	for _,selector in pairs(self.selectors) do
		if selector:getController() == nil then
			n = n + 1
		end
	end
	return n
end

-- Header get bounce move
function Menu:getBounce(f)
	local f = f or 1
	return math.sin(self.header_move*f*math.pi)
end

-- Draw
function Menu:draw()
	-- locals
	local w, h = love.graphics.getWidth()/self.scale, love.graphics.getHeight()/self.scale
	local scale = self.scale
	-- map selection
	love.graphics.setFont(Font)
	love.graphics.printf("Map: " .. self.maplist[self.map], (w/2)*scale, (h/2-22)*scale, 150, "center", 0, scale, scale, 75, 4)
	-- character selection
	for _,selector in pairs(self:getSelectorsAll()) do
		selector:draw()
	end
	-- countdown
	local countdown, _ = math.modf(self.countdown)
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
	-- footer
	love.graphics.setFont(Font)
	love.graphics.printf("Use W,S,A,D,G,H or Arrows,Enter,Rshift or Gamepad\n\nA game by Awesomenauts Community\nSeltzy, ParaDoX, MilkingChicken, Burningdillo, Bronkey, Aki, 04font\nBased on a game by Jan Willem Nijman, Paul Veer and Bits_Beats XOXO", (w/2)*scale, (h-42)*scale, 336, "center", 0, scale, scale, 168, 4)
end

-- Upadte
function Menu:update(dt)
	local state = true
	if self:getSelectorsNumberActive() > 1 then
		for _,selector in pairs(self:getSelectorsActive()) do
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
	for _,v in pairs(self:getSelectorsActive()) do
		if v == selector then
			i = _
			break
		end
	end
	if i ~= 0 then
		self:assignController(selector:getController())
		selector:clear()
	end
end

-- Controllers
function Menu:assignController(controller)
	controller:setParent(self)
end

function Menu:controllerPressed(control, controller)
	-- assign to character selection
	if control == "attack" then
		local selector = self:getSelectorsInactive()[1]
		if selector ~= nil then
			selector:assignController(controller)
		end
	end
	-- map selection chaos!
	if control == "left" then
		if self.map ~= 1 then
			self.map = self.map - 1
		else
			self.map = #self.maplist
		end
	end
	if control == "right" then
		if self.map ~= #self.maplist then
			self.map = self.map + 1
		else
			self.map = 1
		end
	end
end

-- It just must be here
function Menu:controllerReleased(control, controller)
end

function Menu:getNauts()
	local nauts = {}
	for _,selector in pairs(self:getSelectorsActive()) do
		table.insert(nauts, {selector:getSelectionName(), selector:getController()})
	end
	return nauts
end

-- WARUDO
function Menu:startGame()
	local world = World:new(self.maplist[self.map], self:getNauts())
	changeScene(world)
end
