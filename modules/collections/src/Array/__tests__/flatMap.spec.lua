-- Some tests are adapted from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flatMap
return function()
	local flatMap = require("../flatMap")
	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("should flatten arrays returned from callback function", function()
		local arr = { 1, 2, 3, 4 }
		jestExpect(flatMap(arr, function(x: number)
			return { x, x * 2 }
		end)).toEqual({ 1, 2, 2, 4, 3, 6, 4, 8 })
	end)

	it("should flatten arrays returned from callback function only one level deep", function()
		local arr = { 1, 2, 3, 4 }
		jestExpect(flatMap(arr, function(x: number)
			return { { x * 2 } }
		end)).toEqual({ { 2 }, { 4 }, { 6 }, { 8 } })
	end)

	it("should flatten arrays returned from callback function only one level deep - second example", function()
		local arr = { 1, 2, 3, 4 }
		jestExpect(flatMap(arr, function(x: number)
			return { x :: number | { number }, { x * 2 } }
		end)).toEqual({ 1 :: number | { number }, { 2 }, 2, { 4 }, 3, { 6 }, 4, { 8 } })
	end)
end
