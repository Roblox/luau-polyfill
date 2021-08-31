local Array = script.Parent
local isArray = require(Array.isArray)
local LuauPolyfill = Array.Parent
local instanceof = require(LuauPolyfill.instanceof)
local Set

return function(value, mapFn)
	if not Set then
		Set = require(LuauPolyfill.Set :: any)
	end

	if value == nil then
		error("cannot create array from a nil value")
	end
	local valueType = typeof(value)

	local array = {}

	if valueType == "table" and isArray(value) then
		if mapFn then
			for i = 1, #value do
				array[i] = mapFn(value[i], i)
			end
		else
			for i = 1, #value do
				array[i] = value[i]
			end
		end
	elseif instanceof(value, Set) then
		if mapFn then
			for i, v in value:ipairs() do
				array[i] = mapFn(v, i)
			end
		else
			for i, v in value:ipairs() do
				array[i] = v
			end
		end
	elseif valueType == "string" then
		if mapFn then
			for i = 1, value:len() do
				array[i] = mapFn(value:sub(i, i), i)
			end
		else
			for i = 1, value:len() do
				array[i] = value:sub(i, i)
			end
		end
	end

	return array
end
