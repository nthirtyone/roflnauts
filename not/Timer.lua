Timer = require "not.Trigger":extends()

function Timer:new (delay)
	Timer.__super.new(self)
	self.delay = delay
	self.left = 0
	self.active = false
	self.restart = false
end

function Timer:start ()
	self.left = self.delay
	self.active = true
end

function Timer:update (dt)
	if self.active then
		if self.left < 0 then
			self:emit()
			self.active = false
			if self.restart then
				self:start()
			end
		else
			self.left = self.left - dt
		end
	end
end

return Timer
