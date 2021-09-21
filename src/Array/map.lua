--!strict

type Array = { [number]: any }
type callbackFn = (element: any, index: number?, array: Array?) -> any
type callbackFnWithThisArg = (thisArg: any, element: any, index: number?, array: Array?) -> any
type Object = { [string]: any }

-- Implements Javascript's `Array.prototype.map` as defined below
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map
return function(t: Array, callback: callbackFn | callbackFnWithThisArg, thisArg: Object?): Array
	if typeof(t) ~= "table" then
		error(string.format("Array.map called on %s", typeof(t)))
	end
	if typeof(callback) ~= "function" then
		error("callback is not a function")
	end

	local len = #t
	local A = {}
	local k = 1

	while k <= len do
		local kValue = t[k]

		if kValue ~= nil then
			local mappedValue

			if thisArg ~= nil then
				mappedValue = (callback :: callbackFnWithThisArg)(thisArg, kValue, k, t)
			else
				mappedValue = (callback :: callbackFn)(kValue, k, t)
			end

			A[k] = mappedValue
		end
		k += 1
	end

	return A
end
