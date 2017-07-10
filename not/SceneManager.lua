-- Pretend you didn't see this
-- This is work for scene manager
-- TODO: Create SceneManager or similar class.
Scene = nil
function changeScene (scene)
	if Scene ~= nil then
		Scene:delete()
	end
	Scene = scene
end
