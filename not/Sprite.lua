--- `Sprite`
-- Abstract class for drawable animated entities.
Sprite = {
	animations =--[[table with animations]]nil,
	current =--[[animations.default]]nil,
	image =--[[love.graphics.newImage]]nil,
	frame = 1,
	delay = .1,
}
Sprite.__index = Sprite

-- Constructor of `Sprite`.
function Sprite:new (imagePath)
	local o = setmetatable({}, self)
	o:init(imagePath)
	return o
end

-- Cleans up reference to image on deletion.
function Sprite:delete ()
	self.image = nil
end

-- Initializes new Sprite instance.
function Sprite:init (imagePath)
	if type(imagePath) == "string" then
		self:setImage(Sprite.newImage(imagePath))
	end
end

-- Creates new Image object from path. Key-colours two shades of green. Static.
function Sprite.newImage (path)
	local imagedata = love.image.newImageData(path)
	local transparency = function(x, y, r, g, b, a)
		if (r == 0 and g == 128 and b == 64) or
		   (r == 0 and g == 240 and b ==  6) then
			a = 0
		end
		return r, g, b, a
	end
	imagedata:mapPixel(transparency)
	local image = love.graphics.newImage(imagedata)
	return image
end

-- Sets an Image as an image.
function Sprite:setImage (image)
	self.image = image
end
-- Returns current image Image.
function Sprite:getImage ()
	return self.image
end

-- Sets new animations list.
function Sprite:setAnimationsList (t)
	if t then
		self.animations = t
		self:setAnimation("default")
	end
end

-- Sets current animation by table key.
function Sprite:setAnimation (animation)
	self.frame = 1
	self.delay = Sprite.delay -- INITIAL from metatable
	self.current = self.animations[animation]
end
-- Returns current animation table.
function Sprite:getAnimation ()
	return self.current
end

-- Get frame quad for drawing.
function Sprite:getQuad ()
	if self.animations and self.current then
		return self.current[self.frame]
	end
end

-- Drawing self to LOVE2D buffer.
-- If there is no Quad, it will draw entire image. It won't draw anything if there is no image.
-- TODO: it doesn't follow same pattern as `not.Hero.draw`. It should implement so it can be called from `not.World`.
function Sprite:draw (...)
	local i, q = self:getImage(), self:getQuad()
	if i then
		love.graphics.setColor(255,255,255,255)
		if q then love.graphics.draw(i, q, ...)
		else love.graphics.draw(i, ...) end
	end
end
-- Animation updating.
function Sprite:update (dt)
	if self.animations and self.current then
		self.delay = self.delay - dt
		if self.delay < 0 then
			self.delay = self.delay + Sprite.delay -- INITIAL from metatable
			self:goToNextFrame()
		end
	end
end
-- Moving to the next frame.
function Sprite:goToNextFrame ()
	if self.current.repeated or not (self.frame == self.current.frames) then
		self.frame = (self.frame % self.current.frames) + 1
	else
		self:setAnimation("default")
	end
end