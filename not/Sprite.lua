require "not.Object"

--- `Sprite`
-- Abstract class for drawable animated entities.
Sprite = Object:extends()

Sprite.animations =--[[table with animations]]nil
Sprite.current =--[[animations.default]]nil
Sprite.image =--[[love.graphics.newImage]]nil
Sprite.frame = 1
Sprite.delay = .1

-- Constructor of `Sprite`.
-- TODO: Sprites' in general don't take actual Image in constructor. That is not only case of Decoration.
function Sprite:new (imagePath)
	if type(imagePath) == "string" then
		self:setImage(Sprite.newImage(imagePath))
	end
end

-- Cleans up reference to image on deletion.
function Sprite:delete ()
	self.image = nil
end

-- Creates new Image object from path. Key-colours two shades of green. Static.
function Sprite.newImage (path)
	local imagedata = love.image.newImageData(path)
	local transparency = function(x, y, r, g, b, a)
		if (r == 0 and g == 128/255 and b == 64/255) or
		   (r == 0 and g == 240/255 and b ==  6/255) then
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
	self.delay = Sprite.delay -- INITIAL from prototype
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

-- Sprite's position. Can be overriden to add functionality.
function Sprite:getPosition () return 0,0 end
-- Sprite's angle. Can be overriden to add functionality.
function Sprite:getAngle () return 0 end
-- Sprite's horizontal and vertical mirrors. Can be overriden to add functionality.
function Sprite:getHorizontalMirror () return 1 end
function Sprite:getVerticalMirror () return 1 end
-- Sprite's drawing offset from position. Can be overriden to add functionality.
function Sprite:getOffset () return 0,0 end

-- Drawing self to LOVE2D buffer.
-- If there is no Quad, it will draw entire image. It won't draw anything if there is no image.
-- TODO: Sprite@draw requires a serious review!
-- TODO: it doesn't follow same pattern as `not.Hero.draw`. It should implement so it can be called from `not.World`.
-- TODO: change children if above changes are in effect: `not.Platform`, `not.Decoration`.
function Sprite:draw (debug)
	local i, q = self:getImage(), self:getQuad()
	local x, y = self:getPosition()
	local angle = self:getAngle()

	local scaleX = self:getHorizontalMirror()
	local scaleY = self:getVerticalMirror()

	-- pixel grid ; `approx` selected to prevent floating characters on certain conditions
	local approx = math.floor
	if (y - math.floor(y)) > 0.5 then approx = math.ceil end
	local draw_y = approx(y)
	local draw_x = math.floor(x)

	if i and not self.hidden then
		love.graphics.setColor(1, 1, 1, 1)
		if q then 
			love.graphics.draw(i, q, draw_x, draw_y, angle, scaleX, scaleY, self:getOffset())
		else 
			love.graphics.draw(i, draw_x, draw_y, angle, scaleX, scaleY, self:getOffset())
		end
	end
end

-- Animation updating.
function Sprite:update (dt)
	if self.animations and self.current then
		self.delay = self.delay - dt
		if self.delay < 0 then
			self.delay = self.delay + Sprite.delay -- INITIAL from prototype
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

return Sprite
