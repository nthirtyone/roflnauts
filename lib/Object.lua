--- You may not believe me but we are not returning this one.
-- This table is used as metatable for classes e.g. for `Object`.
local Class = {}

--- Metamethod for classes.
-- Creates new instance of class calling `new()` method (constructor) with all parameters passed.
Class.__call = function (self, ...)
	local o = setmetatable({}, self)
	self.new(o, ...)
	return o
end

--- Metamethod for classes.
-- First checks if `__index` (instance prototype) have field we are looking for. Then it tries to find it in super class.
Class.__index = function (self, key)
	if rawget(self, "__index") ~= nil then
		if rawget(self, "__index")[key] ~= nil then
			return rawget(self, "__index")[key]
		end
	end
	if rawget(self, "__super") ~= nil then
		if rawget(self, "__super")[key] ~= nil then
			return rawget(self, "__super")[key]
		end
	end
	return nil
end
--- Metamethod for classes.
-- Redirects creating new properties to class'es `__index` which is used as a prototype for instances of class.
-- Only `new` method and metamethods are allowed to be written to class'es table directly.
Class.__newindex = function(self, key, value)
	if key == "new" or key:sub(1, 2) == "__" then
		rawset(self, key, value)
	else
		self.__index[key] = value
	end
end

--- Creates new class from parent class.
-- New class will call parent's constructor unless new constructor will be defined.
-- @param parent super class of new class
local extends = function (parent)
	local self = setmetatable({}, Class)
	rawset(self, "__index", {})
	if parent then
		setmetatable(self.__index, {__index = parent.__index})
	end
	rawset(self, "__super", parent)
	return self
end

--- Almost empty class.
-- Used to create new classes via `extend()` method:
-- `Child = Object:extend()`
-- Contains `is()` and `new()` methods. Later one isn't available from inside of instances.
local Object = extends(nil)
rawset(Object, "extends", extends)
Object.new = function (self) end

--- Checks if class or instance of class is a child of class passed through parameter.
-- @param class table we want to test against (preferably class table)
-- @return boolean which is false if tested sample is not child of passed class
function Object:is (class)
	if not class then return false end
	if self == class or getmetatable(self) == class then
		return true
	end
	if self.__super then
		return self.__super:is(class)
	end
	if getmetatable(self).__super then
		return getmetatable(self).__super:is(class)
	end
	return false
end

return Object
