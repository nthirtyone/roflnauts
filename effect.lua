-- `Effect`
-- Short animation with graphics that plays in various situation.

-- Metatable of `Effect`
-- nils initialized in constructor
Effect = {
	x = 0,
	y = 0,
	delay = 0.08,
	initial = nil,
	frame = 1,
	animation = nil,
	sprite = love.graphics.newImage("assets/effects.png"),
	quads = {
		jump = {
			[1] = love.graphics.newQuad(  0,  0, 24,24, 168,120),
			[2] = love.graphics.newQuad( 24,  0, 24,24, 168,120),
			[3] = love.graphics.newQuad( 48,  0, 24,24, 168,120),
			[4] = love.graphics.newQuad( 72,  0, 24,24, 168,120),
			frames = 4
		},
		doublejump = {
			[1] = love.graphics.newQuad(  0, 24, 24,24, 168,120),
			[2] = love.graphics.newQuad( 24, 24, 24,24, 168,120),
			[3] = love.graphics.newQuad( 48, 24, 24,24, 168,120),
			[4] = love.graphics.newQuad( 72, 24, 24,24, 168,120),
			frames = 4
		},
		land = {
			[1] = love.graphics.newQuad(  0, 48, 24,24, 168,120),
			[2] = love.graphics.newQuad( 24, 48, 24,24, 168,120),
			[3] = love.graphics.newQuad( 48, 48, 24,24, 168,120),
			[4] = love.graphics.newQuad( 72, 48, 24,24, 168,120),
			[5] = love.graphics.newQuad( 96, 48, 24,24, 168,120),
			frames = 5
		},
		respawn = {},
		clash = {},
		trail = {},
		hit = {}
	}
}

-- NAME      :POSITION :SIZE :FRAMES
-- jump      :x  0 y  0: 24px: 4
-- doublejump:x  0 y 24: 24px: 4
-- land      :x  0 y 48: 24px: 5
-- respawn   :x  0 y 72: 24px: 7
-- clash     :x  0 y 96: 24px: 6
-- trail     :x104 y  0: 16px: 4
-- hit       :x106 y 18: 16px: 3

-- Construct of `Effect`
function Effect:new(name, x, y)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Set filter
	local min, mag = self.sprite:getFilter()
	if min ~= "nearest" or
	   mag ~= "nearest" then
		self.sprite:setFilter("nearest", "nearest")
	end
	-- Init
	o.initial = o.delay
	o.animation = name
	o.x = x or self.x
	o.y = y or self.y
	return o
end

-- Animation and return flag for deletion after completion
-- returns true if completed and ready to delete
function Effect:update(dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		if self.frame < self.quads[self.animation].frames then
			self.frame = self.frame + 1
			self.delay = self.delay + self.initial
		else
			return true -- delete
		end
	end
	return false
end

-- Draw me with scale and offsets, senpai
function Effect:draw(offset_x, offset_y, scale)
	-- defaults
	local offset_x = offset_x or 0
	local offset_y = offset_y or 0
	local scale = scale or 1
	-- draw
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.sprite, self.quads[self.animation][self.frame], (self.x+offset_x)*scale, (self.y+offset_y)*scale, 0, scale, scale)
end