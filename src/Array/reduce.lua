--!strict

type Array = { [number]: any };
type Function = (any, any, any, any) -> any;

-- Implements Javascript's `Array.prototype.reduce` as defined below
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce
return function(t: Array, callback: Function, initialValue: any?): any
	if typeof(t) ~= "table" then
		error(string.format("Array.reduce called on %s", typeof(t)))
	end
	if typeof(callback) ~= "function" then
		error("callback is not a function")
	end

	local len = #t

	local k = 0
	local value

	if initialValue ~= nil then
		value = initialValue
	else
		-- lua has undefined behavior on non-sequences
		-- while k < len and t[k + 1] == nil do
		-- 	k = k + 1
		-- end

		-- if k >= len and initialValue == nil then
		-- 	error("Reduce of empty array with no initial value")
		-- end
		value = t[k + 1]
		k = k + 1
	end

	while k < len do
		if t[k + 1] ~= nil then
			value = callback(value, t[k + 1], k, t)
		end
		k = k + 1
	end

	return value
end
