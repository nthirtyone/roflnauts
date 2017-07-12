--- `SceneManager`
-- Used for changing single active scene.
-- TODO: Extend functionality for more than one active scene (eg. overlay menu).
SceneManager = require "not.Object":extends()

function SceneManager:changeScene (scene)
	if self.scene ~= nil then
		self.scene:delete()
	end
	self.scene = scene
end

function SceneManager:getScene ()
	return self.scene
end

function SceneManager:update (dt)
	self:getScene():update(dt)
end

function SceneManager:draw ()
	self:getScene():draw()
end

function SceneManager:controlpressed (set, action, key)
	self:getScene():controlpressed(set, action, key)
end

function SceneManager:controlreleased (set, action, key)
	self:getScene():controlreleased(set, action, key)
end

return SceneManager
