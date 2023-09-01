--!strict
local __DEV__ = _G.__DEV__
local Array = script.Parent
local Packages = Array.Parent.Parent
local isArray = require(Array.isArray)
local types = require(Packages.ES7Types)
type Array<T> = types.Array<T>

return function<T>(value: Array<T>): T?
	if __DEV__ then
		if not isArray(value) then
			error(string.format("Array.shift called on non-array %s", typeof(value)))
		end
	end

	if #value > 0 then
		return table.remove(value, 1)
	else
		return nil
	end
end
