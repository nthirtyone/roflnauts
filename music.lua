-- `Music`
-- Simple music player object that plays and loops selected track in single Scene.

-- WHOLE CODE HAS FLAG OF "need a cleanup"

-- Metatable of `Music`
-- nils initialized in constructor
Music = {
	track = nil,
	source = nil
}
function Music:new(track)
	-- Meta
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Init
	o.track = track
	o.source = love.audio.newSource("assets/music/" .. o.track)
	o.source:setLooping(true)
	o.source:setVolume(.7)
	o.source:play()
	return o
end
function Music:delete()
	self.source:stop()
end