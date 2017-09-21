Trap = require "not.PhysicalBody":extends()

function Trap:new (direction, x, y, world, imagePath)
	Trap.__super.new(self, x, y, world, imagePath)
	self:setAnimationsList(require("config.animations.flames"))
	self:setBodyType("static")

	local mirror = 1
	if direction == "left" then	mirror = -1 end
	local fixture = self:addFixture({0, 0, 41 * mirror, 0, 41 * mirror, 18, 0, 18})
	fixture:setCategory(4)
	fixture:setMask(1,3,4)
	fixture:setUserData({direction})
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
