--!strict
local Array = script.Parent
local Packages = Array.Parent.Parent
local types = require(Packages.ES7Types)
type Array<T> = types.Array<T>
local map = require(Array.map)

return function<T>(arr: Array<T>, separator: string?): string
	if #arr == 0 then
		return ""
	end
	-- JS does tostring conversion implicitely but in Lua we need to do that explicitely
	local stringifiedArray = map(arr, function(item)
		return tostring(item)
	end)

	return table.concat(stringifiedArray, separator or ",")
end
