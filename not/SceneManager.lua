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

return SceneManager
