require "not.Object"

--- `MusicPlayer`
-- Simple music player object that plays and loops selected track.
MusicPlayer = Object:extends()

function MusicPlayer:new (trackName)
	self.tracks = {}
	self:setTrack(trackName)
end

function MusicPlayer:delete ()
	self.tracks = nil
	self.source:stop()
end

function MusicPlayer:setTrack (trackName)
	if self.source then
		self.source:stop()
	end
	if self.tracks[trackName] then
		self.source = self.tracks[trackName]
	else
		local source = love.audio.newSource("assets/music/" .. trackName)
		source:setLooping(true)
		source:setVolume(.7)
		self.source = source
		self.tracks[trackName] = source
	end
	self.source:play()
end

return MusicPlayer
