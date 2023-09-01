local __DEV__ = _G.__DEV__
local Array = script.Parent
local Packages = Array.Parent.Parent
local isArray = require(Array.isArray)
local types = require(Packages.ES7Types)
type Array<T> = types.Array<T>
local function flat<T>(array: Array<T>, depth_: number?): Array<T>
	if __DEV__ then
		if typeof(array) ~= "table" then
			error(string.format("Array.flat called on %s", typeof(array)))
		end
		if depth_ ~= nil and typeof(depth_) ~= "number" then
			error("depth is not a number or nil")
		end
	end
	local depth = depth_ or 1
	local newArray = {}

	for _, v in array do
		if isArray(v) then
			local vArray = (v :: any) :: Array<T>
			local innerArrFlat: Array<T> = if depth > 1 then flat(vArray, depth - 1) else vArray
			for _, innerValue in innerArrFlat do
				table.insert(newArray, innerValue)
			end
		else
			table.insert(newArray, v)
		end
	end

	return newArray
end

return flat
