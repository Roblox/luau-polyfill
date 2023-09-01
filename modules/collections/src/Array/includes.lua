--!strict
local Array = script.Parent
local Packages = Array.Parent.Parent
local types = require(Packages.ES7Types)
type Array<T> = types.Array<T>
local indexOf = require(script.Parent.indexOf)

return function<T>(array: Array<T>, searchElement: T, fromIndex: number?): boolean
	return indexOf(array, searchElement, fromIndex) ~= -1
end
