local button = require "button"

return {
	button
		:new("start")
		:setPosition(10,40)
		:set("active", function ()
				changeScene(Menu:new("menustart"))
			end)
	,
	button
		:new("join")
		:setPosition(10,50)
	,
	button
		:new("settings")
		:setPosition(10,60)
	,
	button
		:new("credits")
		:setPosition(10,70)
	,
	button
		:new("exit")
		:setPosition(10,80)
		:set("active", love.event.quit)
	,
}