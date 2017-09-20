Trap = require "not.PhysicalBody":extends()

-- TODO: Move flames' animations to config file.
local animations = {
	default = {
		[1] = love.graphics.newQuad(0, 0, 42, 19, 168, 19),
		[2] = love.graphics.newQuad(42, 0, 42, 19, 168, 19),
		frames = 2,
		repeated = true
	},
	fadein = {
		[1] = love.graphics.newQuad(84, 0, 42, 19, 168, 19),
		[2] = love.graphics.newQuad(126, 0, 42, 19, 168, 19),
		frames = 2,
		repeated = false
	},
	fadeout = {
		[1] = love.graphics.newQuad(126, 0, 42, 19, 168, 19),
		[2] = love.graphics.newQuad(84, 0, 42, 19, 168, 19),
		frames = 2,
		repeated = false
	}
}

function Trap:new (direction, x, y, world, imagePath)
	Trap.__super.new(self, x, y, world, imagePath)
	self:setAnimationsList(animations)
	self:setBodyType("static")

	local mirror = 1
	if direction == "left" then	mirror = -1 end
	local fixture = Trap.__super.addFixture(self, {0, 0, 41 * mirror, 0, 41 * mirror, 18, 0, 18})
	fixture:setCategory(3)
	fixture:setMask(1)
	fixture:setUserData({0, direction})
	fixture:setSensor(true)

	self.mirror = mirror
end

function Trap:fadeIn ()
	self.hidden = false
	self:setBodyActive(true)
	if self.animations.fadein then
		self:setAnimation("fadein")
	end
end

function Trap:fadeOut ()
	self:setBodyActive(false)
	if self.animations.fadeout then
		self:setAnimation("fadeout")
	else
		self.hidden = true
	end
end

function Trap:getHorizontalMirror ()
	return self.mirror
end

function Trap:goToNextFrame ()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	elseif self.current == self.animations.fadeout then
		self:setAnimation("default")
		self.hidden = true
	else
		self:setAnimation("default")
	end
end

-- TODO: Trap@damage is hotfix for clashing.
function Trap:damage () end

return Trap
