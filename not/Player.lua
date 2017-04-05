--- `Player`
-- Special `not.Hero` controllable by a player.
Player = {
	-- TODO: move functions and properties related to controls from `not.Hero`.
	controlSet = --[[Controller.sets.*]]nil,
}

-- `Player` is a child of `Hero`.
require "not.Hero"
Player.__index = Player
setmetatable(Player, Hero)

-- Constructor of `Player`.
-- TODO: I'm sure it is a duplicate, but `not.World.create*` methods need to pass proper parameters.
function Player:new (name, game, x, y)
	local o = setmetatable({}, self)
	o:init(name, game, x, y)
	-- Load portraits statically to `not.Hero`.
	-- TODO: this is heresy, put it into `load` method or something similar.
	if Hero.portrait_sprite == nil then
		Hero.portrait_sprite = love.graphics.newImage("assets/portraits.png")
		Hero.portrait_frame = love.graphics.newImage("assets/menu.png")
	end
	return o
end

-- Initializer of `Player`.
function Player:init (...)
	Hero.init(self, ...)
end

-- Controller set manipulation.
function Player:assignControlSet (set)
	self.controlset = set
end
function Player:getControlSet ()
	return self.controlset
end
