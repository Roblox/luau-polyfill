-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach
return function()
	local Array = script.Parent.Parent
	local LuauPolyfill = Array.Parent
	local forEach = require(Array.forEach)
	local isArray = require(Array.isArray)

	local Packages = LuauPolyfill.Parent
	local JestModule = require(Packages.Dev.JestGlobals)
	local jestExpect = JestModule.expect
	local jest = JestModule.jest

	it("Invalid argument", function()
		-- roblox-cli analyze fails because forEach is called with an
		-- invalid argument, so it needs to be cast to any
		local forEachAny: any = forEach
		jestExpect(function()
			forEachAny(nil, function() end)
		end).toThrow()
		jestExpect(function()
			forEachAny({ 0, 1 }, nil)
		end).toThrow()
	end)

	it("forEach an array of numbers", function()
		local mock = jest.fn()
		local numbers = { 1, 4, 9 }
		forEach(numbers, function(num)
			mock(num)
		end)
		jestExpect(mock).toHaveBeenCalledWith(1)
		jestExpect(mock).toHaveBeenCalledWith(4)
		jestExpect(mock).toHaveBeenCalledWith(9)
	end)

	it("forEach an array of numbers with a hole", function()
		local mock = jest.fn()
		local numbers = { 1, 4, 9 }
		numbers[2] = nil
		forEach(numbers, function(num)
			mock(num)
		end)
		jestExpect(mock).toHaveBeenCalledWith(1)
		jestExpect(mock).toHaveBeenCalledWith(nil)
		jestExpect(mock).toHaveBeenCalledWith(9)
	end)

	it("forEach an array of numbers with a mixed field inserted", function()
		local mock = jest.fn()
		local numbers = { 1, 4, 9 }
		numbers["NotANumber" :: any] = "mixed" :: any
		forEach(numbers, function(num)
			mock(num)
		end)
		jestExpect(mock).toHaveBeenCalledWith(1)
		jestExpect(mock).toHaveBeenCalledWith(4)
		jestExpect(mock).toHaveBeenCalledWith(9)
	end)

	it("forEach on an array of tables", function()
		local mock = jest.fn()
		local kvArray = {
			{ key = 1, value = 10 },
			{ key = 2, value = 20 },
			{ key = 3, value = 30 },
		}
		forEach(kvArray, function(obj)
			mock(obj)
		end)
		jestExpect(mock).toHaveBeenCalledWith({ key = 1, value = 10 })
		jestExpect(mock).toHaveBeenCalledWith({ key = 2, value = 20 })
		jestExpect(mock).toHaveBeenCalledWith({ key = 3, value = 30 })
	end)

	it("removing items from the array during iteration", function()
		local words = { "one", "two", "three", "four" }
		local mock = jest.fn()

		forEach(words, function(word)
			mock(word)
			if word == "two" then
				table.remove(words, 1)
			end
		end)

		jestExpect(mock).toHaveBeenCalledWith("one")
		jestExpect(mock).toHaveBeenCalledWith("two")
		jestExpect(mock).never.toHaveBeenCalledWith("three")
		jestExpect(mock).never.toHaveBeenCalledWith(nil)
		jestExpect(mock).toHaveBeenCalledWith("four")
	end)

	it("adding items from the array during iteration", function()
		local words = { "one", "two", "three", "four" }
		local mock = jest.fn()

		forEach(words, function(word, _index, array)
			mock(word)
			table.insert(array, "five")
		end)

		jestExpect(mock).toHaveBeenCalledWith("one")
		jestExpect(mock).toHaveBeenCalledWith("two")
		jestExpect(mock).toHaveBeenCalledWith("three")
		jestExpect(mock).toHaveBeenCalledWith("four")
		jestExpect(mock).never.toHaveBeenCalledWith(nil)
		jestExpect(mock).never.toHaveBeenCalledWith("five")
	end)

	it("Flatten an array", function()
		local flatten
		flatten = function(arr)
			local result = {}
			forEach(arr, function(i)
				if isArray(i) then
					for _, v in ipairs(flatten(i)) do
						table.insert(result, v)
					end
				else
					table.insert(result, i)
				end
			end)

			return result
		end

		-- Luau FIXME: Luau should realize this isn't an array in this single assingment: TypeError: Type '{number}' could not be converted into 'number'
		local nested = { 1, 2, 3, { 4, 5, { 6, 7 } :: any, 8, 9 } :: any }
		jestExpect(flatten(nested)).toEqual({ 1, 2, 3, 4, 5, 6, 7, 8, 9 })
	end)
end
