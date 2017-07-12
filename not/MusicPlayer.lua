require "not.Object"

--- `MusicPlayer`
-- Simple music player object that plays and loops selected track.
MusicPlayer = Object:extends()

function MusicPlayer:new (trackName)
	self.tracks = {}
	if trackName then
		self:setTrack(trackName)
		self:play()
	end
end

function MusicPlayer:delete ()
	self.tracks = nil
	self:stop()
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
end

function MusicPlayer:play ()
	self.source:play()
end

function MusicPlayer:stop ()
	self.source:stop()
end

return MusicPlayer
