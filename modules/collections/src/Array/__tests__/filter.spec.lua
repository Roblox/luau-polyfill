-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter

return function()
	local types = require("@pkg/@jsdotlua/es7-types")
	local filter = require("../filter")
	local isFinite = require("@pkg/@jsdotlua/number").isFinite
	local JestGlobals = (require)("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	type Array<T> = types.Array<T>

	it("Filtering out all small values", function()
		local isBigEnough = function(value)
			return value >= 10
		end

		local filtered = filter({ 12, 5, 8, 130, 44 }, isBigEnough)
		jestExpect(filtered).toEqual({ 12, 130, 44 })
	end)

	it("Find all prime numbers in an array", function()
		local isPrime = function(num)
			local i = 2
			while num > i do
				if num % i == 0 then
					return false
				end
				i += 1
			end
			return num > 1
		end

		local filtered = filter({ -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 }, isPrime)
		jestExpect(filtered).toEqual({ 2, 3, 5, 7, 11, 13 })
	end)

	it("Filtering invalid entries from JSON", function()
		local arr = {
			{ id = 15 },
			{ id = -1 },
			{ id = 0 },
			{ id = 3 },
			{ id = 12.2 },
			{} :: any,
			{ id = nil } :: any,
			{ id = 0 / 0 },
			{ id = "undefined" :: any },
		}

		local invalidEntries = 0

		local filterByID = function(item)
			if isFinite(item.id) and item.id ~= 0 then
				return true
			end
			invalidEntries += 1
			return false
		end

		local arrByID = filter(arr, filterByID)
		jestExpect(arrByID).toEqual({
			{ id = 15 },
			{ id = -1 },
			{ id = 3 },
			{ id = 12.2 },
		})
		jestExpect(invalidEntries).toEqual(5)
	end)

	it("Searching in array", function()
		local fruits = { "apple", "banana", "grapes", "mango", "orange" }
		local filterItems = function(arr, query)
			return filter(arr, function(el)
				return string.find(el, query) ~= nil
			end)
		end

		jestExpect(filterItems(fruits, "ap")).toEqual({ "apple", "grapes" })
		jestExpect(filterItems(fruits, "an")).toEqual({
			"banana",
			"mango",
			"orange",
		})
	end)

	describe("Affecting Initial Array", function()
		it("Modifying initial array", function()
			local words = {
				"spray",
				"limit",
				"exuberant",
				"destruction",
				"elite",
				"present",
			}

			local modifiedWords = filter(words, function(word, index, arr)
				-- Luau FIXME: I cannot get the narrowing to work here: TypeError: Value of type 'Array<any>?' could be nil
				if arr == nil or index == nil then
					return false
				end

				if (arr :: Array<any>)[index :: number + 1] == nil then
					(arr :: Array<any>)[index :: number + 1] = "undefined"
				end
				(arr :: Array<any>)[index :: number + 1] = (arr :: Array<any>)[index :: number + 1] .. " extra"
				return #word < 6
			end)

			jestExpect(modifiedWords).toEqual({ "spray" })
		end)

		it("Appending to initial array", function()
			local words = {
				"spray",
				"limit",
				"exuberant",
				"destruction",
				"elite",
				"present",
			}

			local modifiedWords = filter(words, function(word, index, arr)
				if arr == nil then
					return false
				end
				table.insert(arr :: Array<any>, "new")
				return #word < 6
			end)

			jestExpect(modifiedWords).toEqual({ "spray", "limit", "elite" })
		end)

		it("Deleting from initial array", function()
			local words = {
				"spray",
				"limit",
				"exuberant",
				"destruction",
				"elite",
				"present",
			}

			local modifiedWords = filter(words, function(word, index, arr)
				if arr == nil then
					return false
				end
				table.remove(arr :: Array<any>)
				return #word < 6
			end)

			jestExpect(modifiedWords).toEqual({ "spray", "limit" })
		end)
	end)
end
