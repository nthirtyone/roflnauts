--- `MenuBackground`
-- Represented as space background with blinking stars and moving asteroids.
-- It might be too specific, but whatever. It is still better than hardcoded background in `Menu` class.
MenuBackground = require "not.Element":extends()

MenuBackground.BASE_STARS_DELAY = .8
MenuBackground.QUAD_STARS = {
	love.graphics.newQuad(  0, 0, 320, 200, 640,200),
	love.graphics.newQuad(320, 0, 320, 200, 640,200)
}

function MenuBackground:new (parent)
	MenuBackground.__super.new(parent)
	self.starsFrame = 1
	self.starsDelay = self.BASE_STARS_DELAY
	self.asteroidsBounce = 0
	-- Load statically.
	if MenuBackground.IMAGE_BACKGROUND == nil then
		MenuBackground.IMAGE_BACKGROUND = love.graphics.newImage("assets/backgrounds/menu.png")
		MenuBackground.IMAGE_ASTEROIDS = love.graphics.newImage("assets/asteroids.png")
		MenuBackground.IMAGE_STARS = love.graphics.newImage("assets/stars.png")
	end
end

function MenuBackground:update (dt)
	self.asteroidsBounce = self.asteroidsBounce + dt*0.1
	if self.asteroidsBounce > 2 then
		self.asteroidsBounce = self.asteroidsBounce - 2
	end
	self.starsDelay = self.starsDelay - dt
	if self.starsDelay < 0 then
		self.starsDelay = self.starsDelay + self.BASE_STARS_DELAY
		if self.starsFrame == 2 then
			self.starsFrame = 1
		else
			self.starsFrame = 2
		end
	end
end

function MenuBackground:draw ()
	local scale = self.scale
	local scaler = getRealScale()
	love.graphics.draw(self.IMAGE_BACKGROUND, 0, 0, 0, scaler, scaler)
	love.graphics.draw(self.IMAGE_STARS, self.QUAD_STARS[self.starsFrame], 0, 0, 0, scaler, scaler)
	love.graphics.draw(self.IMAGE_ASTEROIDS, 0, math.floor(64+math.sin(self.asteroidsBounce*math.pi)*4)*scaler, 0, scaler, scaler)
end

return MenuBackground
