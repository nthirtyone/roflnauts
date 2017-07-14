--- `Menu`
-- It creates single screen of a menu
-- I do know that model I used here and in `World` loading configuration files is not flawless but I did not want to rewrite `World`s one but wanted to keep things similar at least in project scope.
Menu = require "not.Scene":extends()

Menu.scale = getScale()
Menu.elements = --[[{not.Element}]]nil
Menu.active = 1
Menu.music = --[[not.Music]]nil
Menu.sprite = --[[love.graphics.newImage]]nil
Menu.allowMove = true
Menu.quads = { -- TODO: Could be moved to config file or perhaps QuadManager to manage all quads for animations etc.
	button = {
		normal = love.graphics.newQuad(0, 0, 58,15, 80,130),
		active = love.graphics.newQuad(0, 0, 58,15, 80,130)
	},
	portrait = {
		normal = love.graphics.newQuad( 0, 15, 32,32, 80,130),
		active = love.graphics.newQuad(32, 15, 32,32, 80,130)
	},
	panorama = {
		normal = love.graphics.newQuad(0,47, 80,42, 80,130),
		active = love.graphics.newQuad(0,88, 80,42, 80,130)
	},
	arrow_l = love.graphics.newQuad(68, 0, 6, 6, 80,130),
	arrow_r = love.graphics.newQuad(74, 0, 6, 6, 80,130),
}

function Menu:new (name)
	-- Load statically.
	if Menu.sprite == nil then
		Menu.sprite = love.graphics.newImage("assets/menu.png")
	end
	-- musicPlayer calls should be moved to menu files; see issue with new win screen
	musicPlayer:setTrack("menu.ogg")
	musicPlayer:play()
	self.elements = {}
	self:open(name)
end

function Menu:delete () end

function Menu:open (name)
	local name = name or "main"
	self.active = Menu.active --Menu.active is initial
	self.elements = love.filesystem.load(string.format("config/menus/%s.lua", name))(self, self.elements[1])
	-- Common with `next` method.
	if not self.elements[self.active]:focus() then
		self:next()
	end
end

-- Return reference to quads table and menu sprite
function Menu:getSheet ()
	return self.sprite, self.quads
end

-- Cycle elements
function Menu:next ()
	self.elements[self.active]:blur()
	self.active = (self.active%#self.elements)+1
	if not self.elements[self.active]:focus() then
		self:next()
	end
end
function Menu:previous ()
	self.elements[self.active]:blur()
	if self.active == 1 then
		self.active = #self.elements
	else
		self.active = self.active - 1
	end
	if not self.elements[self.active]:focus() then
		self:previous()
	end
end

-- LÖVE2D callbacks
function Menu:update (dt)
	for _,element in pairs(self.elements) do
		element:update(dt)
	end
end
function Menu:draw ()
	local scale = self.scale
	local scaler = getRealScale()
	love.graphics.setFont(Font)
	for _,element in pairs(self.elements) do
		element:draw(scale)
	end
end

-- Controller callbacks
function Menu:controlpressed (set, action, key)
	if self.allowMove then
		if action == "down" then
			self:next()
		end
		if action == "up" then
			self:previous()
		end
	end
	for _,element in pairs(self.elements) do
		element:controlpressed(set, action, key)
	end
end
function Menu:controlreleased (set, action, key)
	for _,element in pairs(self.elements) do
		element:controlreleased(set, action, key)
	end
end

return Menu
