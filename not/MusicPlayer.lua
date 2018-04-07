--- Simple music player object that stores, playes and loops tracks..
MusicPlayer = require "not.Object":extends()

function MusicPlayer:new (trackName)
	self.tracks = {}
	if trackName then
		self:setTrack(trackName)
		self:play()
	end
end

function MusicPlayer:delete ()
	self:stop()
	self.tracks = nil
	self.source = nil
end

function MusicPlayer:setTrack (trackName)
	if self.source then
		self.source:stop()
	end
	if self.tracks[trackName] then
		self.source = self.tracks[trackName]
	else
		local source = love.audio.newSource("assets/music/" .. trackName, "stream")
		source:setLooping(true)
		source:setVolume(.7)
		self.source = source
		self.tracks[trackName] = source
	end
end

function MusicPlayer:getCurrentTrack ()
	for key,track in pairs(self.tracks) do
		if self.tracks[key] == self.source then
			return key
		end
	end
end

function MusicPlayer:play (trackName)
	if trackName then
		self:setTrack(trackName)
	end
	self.source:play()
end

function MusicPlayer:stop ()
	self.source:stop()
end

return MusicPlayer
