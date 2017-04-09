--- `Music`
-- Simple music player object that plays and loops selected track in single Scene.
Music = {
	source = --[[love.audio.newSource]]nil
}

Music.__index = Music

function Music:new (trackName)
	local o = setmetatable({}, self)
	o:init(trackName)
	return o
end

-- TODO: trackName should be passed without file extension.
function Music:init (trackName)
	self.source = love.audio.newSource("assets/music/" .. trackName)
	self.source:setLooping(true)
	self.source:setVolume(.7)
	self.source:play()
end

function Music:delete ()
	self.source:stop()
end