require "not.Object"

--- `MusicPlayer`
-- Simple music player object that plays and loops selected track.
MusicPlayer = Object:extends()

MusicPlayer.TRACKS = {}

-- TODO: trackName should be passed without file extension.
function MusicPlayer:new (trackName)
	self:setTrack(trackName)
end

function MusicPlayer:delete ()
	self.source:stop()
end

function MusicPlayer:setTrack (trackName)
	if self.source then
		self.source:stop()
	end
	if MusicPlayer.TRACKS[trackName] then
		self.source = MusicPlayer.TRACKS[trackName]
	else
		local source = love.audio.newSource("assets/music/" .. trackName)
		source:setLooping(true)
		source:setVolume(.7)
		self.source = source
		MusicPlayer.TRACKS[trackName] = source
	end
	self.source:play()
end

return MusicPlayer
