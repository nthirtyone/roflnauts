--- `Scene`
Scene = require "not.Object":extends()

function Scene:new ()
	self.sleeping = false
	self.hidden = false
	self.inputDisabled = false
end

function Scene:delete () end
function Scene:update (dt) end
function Scene:draw () end

-- Following setters and getters are a little bit too much, I think. But they do follow general coding directions.
function Scene:setSleeping (sleeping)
	self.sleeping = sleeping
end
function Scene:isSleeping ()
	return self.sleeping
end

function Scene:setHidden (hidden)
	self.hidden = hidden
end
function Scene:isHidden ()
	return self.hidden
end

function Scene:setInputDisabled (inputDisabled)
	self.inputDisabled = inputDisabled
end
function Scene:isInputDisabled ()
	return self.inputDisabled
end

return Scene
