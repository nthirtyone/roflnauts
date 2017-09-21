Trigger = require "not.Object":extends()

function Trigger:new ()
	self.calls = {}
end

function Trigger:register (func, ...)
	local call = {func = func, params = {...}}
	table.insert(self.calls, call)
end

function Trigger:emit ()
	for _,call in pairs(self.calls) do
		call.func(unpack(call.params))
	end
end

return Trigger
