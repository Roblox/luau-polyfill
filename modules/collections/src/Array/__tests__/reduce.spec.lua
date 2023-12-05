-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce
return function()
	local types = require("@pkg/es7-types")
	type Array<T> = types.Array<T>
	local reduce = require("../reduce")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("calls the reducer function with the indexes", function()
		jestExpect(reduce({ true, false, {}, "foo" } :: Array<any>, function(accumulator, _currentValue, index)
			table.insert(accumulator, index)
			return accumulator
		end, {})).toEqual({ 1, 2, 3, 4 })
	end)

	it("calls the reducer function with the given array", function()
		local originalArray = { true }
		jestExpect(reduce(originalArray, function(_acc, currentValue, _index, array)
			jestExpect(array).toBe(originalArray)
			return currentValue
		end, false)).toEqual(true)
	end)

	it("throws if no initial value is provided and the array is empty", function()
		jestExpect(function()
			reduce({}, function()
				return false
			end)
		end).toThrow("reduce of empty array with no initial value")
	end)

	it("Invalid argument", function()
		-- roblox-cli analyze fails because map is called with an
		-- invalid argument, so it needs to be cast to any
		local reduceAny: any = reduce
		jestExpect(function()
			reduceAny(nil, function()
				return false
			end)
		end).toThrow()
		jestExpect(function()
			reduceAny({ 0, 1 }, nil)
		end).toThrow()
	end)

	it("Sum all the values of an array", function()
		-- TODO Luau: once Luau supports overloads, reduce can be typed to not need this annotation
		jestExpect(reduce({ 1, 2, 3, 4 }, function(accumulator: number, currentValue)
			return accumulator + currentValue
		end)).toEqual(10)
	end)

	it("Sum of values in an object array", function()
		-- TODO Luau: once Luau supports overloads, reduce can be typed to not need this annotation
		jestExpect(reduce({ { x = 1 }, { x = 2 }, { x = 3 } }, function(accumulator: number, currentValue)
			return accumulator + currentValue.x
		end, 0)).toEqual(6)
	end)

	it("Counting instances of values in an object", function()
		local names = { "Alice", "Bob", "Tiff", "Bruce", "Alice" }
		-- TODO Luau: once Luau supports overloads, reduce can be typed to not need this annotation
		local reduced = reduce(names, function(allNames: { [string]: number }, name)
			if allNames[name] ~= nil then
				allNames[name] = allNames[name] + 1
			else
				allNames[name] = 1
			end
			return allNames
		end, {})
		jestExpect(reduced).toEqual({
			Alice = 2,
			Bob = 1,
			Tiff = 1,
			Bruce = 1,
		})
	end)

	it("Grouping objects by a property", function()
		local people = {
			{ name = "Alice", age = 21 },
			{ name = "Max", age = 20 },
			{ name = "Jane", age = 20 },
		}
		local reduced = reduce(people, function(acc, obj)
			local key = obj["age"]
			if acc[key] == nil then
				acc[key] = {}
			end
			table.insert(acc[key], obj)
			return acc
		end, {})
		jestExpect(reduced).toEqual({
			[20] = {
				{ name = "Max", age = 20 },
				{ name = "Jane", age = 20 },
			},
			[21] = {
				{ name = "Alice", age = 21 },
			},
		})
	end)
end
