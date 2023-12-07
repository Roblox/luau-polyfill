return function()
	local findIndex = require("../findIndex")
	local types = require("@pkg/es7-types")
	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	type Array<T> = types.Array<T>

	local function returnTrue()
		return true
	end

	local function returnFalse()
		return false
	end

	it("returns -1 if the array is empty", function()
		jestExpect(findIndex({}, returnTrue)).toEqual(-1)
	end)

	it("returns -1 if the predicate is always false", function()
		jestExpect(findIndex({ 1, 2, 3 }, returnFalse)).toEqual(-1)
	end)

	it("returns the first index where the predicate is true", function()
		local result = findIndex({ 3, 4, 5, 6 }, function(element)
			return element % 2 == 0
		end)
		jestExpect(result).toEqual(2)
	end)

	it("passes the element, its index and the array to the predicate", function()
		local arguments = nil
		local array = { "foo" }
		findIndex(array, function(...)
			arguments = { ... }
			return false
		end)
		jestExpect(arguments).toEqual({ "foo", 1, array } :: Array<any>)
	end)

	-- the following tests were taken from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex
	it("returns first element greater than 13", function()
		local array1 = { 5, 12, 8, 130, 44 }

		local function isLargeNumber(element)
			return element > 13
		end

		jestExpect(findIndex(array1, isLargeNumber)).toEqual(4)
	end)

	it("returns first prime element", function()
		local function isPrime(num: number)
			for i = 2, num - 1 do
				if num % i == 0 then
					return false
				end
			end

			return num > 1
		end

		jestExpect(findIndex({ 4, 6, 8, 9, 12 }, isPrime)).toEqual(-1)
		jestExpect(findIndex({ 4, 6, 7, 9, 12 }, isPrime)).toEqual(3)
	end)

	it("returns first matching string", function()
		local fruits = {
			"apple",
			"banana",
			"cantaloupe",
			"blueberries",
			"grapefruit",
		}

		jestExpect(findIndex(fruits, function(fruit)
			return fruit == "blueberries"
		end)).toEqual(4)
	end)
end
