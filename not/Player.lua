--- `Player`
-- Special `not.Hero` controllable by a player.
Player = {
	-- TODO: move functions and properties related to controls from `not.Hero`.
}

-- `Player` is a child of `Hero`.
require "not.Hero"
Player.__index = Player
setmetatable(Player, Hero)

-- Constructor of `Player`.
function Player:new (...)
	local o = setmetatable({}, self)
	o:init(...)
	return o
end

-- Initializator of `Player`.
function Player:init (...)
	Hero.init(self, ...)
end