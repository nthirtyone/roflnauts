local menu = ...

local button = require "button"

return {
	button:new(menu)
		:setText("Go back")
		:setPosition(10,40)
		:set("active", function ()
				changeScene(Menu:new("menumain"))
			end)
	,
}