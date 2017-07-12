--- `SceneManager`
-- Used for changing single active scene.
-- TODO: Extend functionality for more than one active scene (eg. overlay menu).
SceneManager = require "not.Object":extends()

function SceneManager:new ()
	self.scenes = {}
end

-- This function should be removed when multiple scenes will be handled properly by SceneManager and other things.
function SceneManager:changeScene (scene)
	table.remove(self.scenes, #self.scenes)
	return self:addScene(scene)
end

function SceneManager:addScene (scene)
	table.insert(self.scenes, scene)
	return scene
end

function SceneManager:getAllScenes ()
	return self.scenes
end

function SceneManager:update (dt)
	for _,scene in pairs(self:getAllScenes()) do
		if not scene:isSleeping() then
			scene:update(dt)
		end
	end
end

function SceneManager:draw ()
	for _,scene in pairs(self:getAllScenes()) do
		if not scene:isHidden() then
			scene:draw()
		end
	end
end

function SceneManager:controlpressed (set, action, key)
	for _,scene in pairs(self:getAllScenes()) do
		if not scene:isInputDisabled() then
			scene:controlpressed(set, action, key)
		end
	end
end

function SceneManager:controlreleased (set, action, key)
	for _,scene in pairs(self:getAllScenes()) do
		if not scene:isInputDisabled() then
			scene:controlreleased(set, action, key)
		end
	end
end

return SceneManager
