local menu, background = ...

local Button = require "not.Button"
local Selector = require "not.Selector"

local width, height = love.graphics.getWidth()/getScale(), love.graphics.getHeight()/getScale()
local bx = width/2-29

if background == nil or not background:is(require "not.MenuBackground") then
	background = require "not.MenuBackground"(menu)
end

-- TODO: loadConfigs is duplicated in menus/select and menus/host.
local
function loadConfigs (dir, process)
	local items, icons = {}, {}
	for _,file in pairs(love.filesystem.getDirectoryItems(dir)) do
		local path = string.format("%s/%s", dir, file)
		if love.filesystem.isFile(path) and file ~= "readme.md" then
			local item = love.filesystem.load(path)()
			if item and process(item, file, path) then
				table.insert(icons, love.graphics.newImage(item.portrait))
				table.insert(items, item)
			end
		end
	end
	return items, icons
end

-- TODO: This is temporary solution for generating available maps list and portraits for them to pass to Selector.
local maps, icons = loadConfigs("config/maps", function (map, _, path) map.filename = path; return true end)
local mapSelector = Selector(maps, nil, menu)

return {
	background,
	mapSelector
		:setPosition(width/2-40, 40)
		:set("shape", Selector.SHAPE_PANORAMA)
		:set("icons", icons)
		:set("getText", function (self)
				return self:getSelected().name
			end)
	,
	Button(menu)
		:setText("Next")
		:setPosition(bx,101)
		:set("isEnabled", function ()
				return mapSelector:getLocked()
			end)
		:set("active", function (self)
				MAP = mapSelector:getSelected()
				self.parent:open("select")
			end)
	,
	Button(menu)
		:setText("Go back")
		:setPosition(bx,117)
		:set("active", function (self)
				self.parent:open("main")
			end)
	,
}
