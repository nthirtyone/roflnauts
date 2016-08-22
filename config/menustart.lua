local button = require "button"

return {
	button
		:new("WORKED")
		:setPosition(10,40)
		:set("active", function ()
				changeScene(Menu:new("menumain"))
			end)
	,
}