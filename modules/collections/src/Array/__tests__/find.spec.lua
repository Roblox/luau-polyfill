return function()
	local find = require("../find")
	local types = require("@pkg/es7-types")
	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	type Array<T> = types.Array<T>

	local function returnTrue()
		return true
	end

	local function returnFalse()
		return false
	end

	it("returns nil if the array is empty", function()
		jestExpect(find({}, returnTrue)).toEqual(nil)
	end)

	it("returns nil if the predicate is always false", function()
		jestExpect(find({ 1, 2, 3 }, returnFalse)).toEqual(nil)
	end)

	it("returns the first element where the predicate is true", function()
		local result = find({ 3, 4, 5, 6 }, function(element)
			return element % 2 == 0
		end)
		jestExpect(result).toEqual(4)
	end)

	it("passes the element, its index and the array to the predicate", function()
		local arguments = nil
		local array = { "foo" }
		find(array, function(...)
			arguments = { ... }
			return false
		end)
		jestExpect(arguments).toEqual({ "foo", 1, array } :: Array<any>)
	end)
end
