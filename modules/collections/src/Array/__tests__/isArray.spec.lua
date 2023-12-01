-- Tests partially based on examples from:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/isArray
return function()
	local Map = require("../../init").Map
	local types = require("@pkg/es7-types")
	type Array<T> = types.Array<T>
	local isArray = require("../isArray")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns false for non-tables", function()
		jestExpect(isArray(nil)).toEqual(false)
		jestExpect(isArray(1)).toEqual(false)
		jestExpect(isArray("hello")).toEqual(false)
		jestExpect(isArray(function() end)).toEqual(false)
		jestExpect(isArray(newproxy(false))).toEqual(false)
	end)

	it("returns false for tables with non-number keys", function()
		jestExpect(isArray({ hello = 1 })).toEqual(false)
		jestExpect(isArray({ [function() end] = 1 })).toEqual(false)
		jestExpect(isArray({ [newproxy(false)] = 1 })).toEqual(false)
		jestExpect(isArray(Map.new())).toEqual(false)
	end)

	it("returns false for a table with non-integer key", function()
		jestExpect(isArray({ [0.5] = true })).toEqual(false)
	end)

	it("returns false for a table with a key equal to zero", function()
		jestExpect(isArray({ [0] = true })).toEqual(false)
	end)

	it("returns true for an empty table", function()
		jestExpect(isArray({})).toEqual(true)
	end)

	it("returns false for sparse arrays", function()
		jestExpect(isArray({
			[1] = "1",
			[3] = "3",
		})).toEqual(false)
		local noFours = {}
		noFours[5] = "5"
		noFours[3] = "3"
		noFours[1] = "1"
		noFours[2] = "2"
		jestExpect(isArray(noFours)).toEqual(false)
		jestExpect(isArray({
			[3] = "3",
			[2] = "2",
		})).toEqual(false)
	end)

	it("returns false for tables with non-positive-number keys", function()
		jestExpect(isArray({
			[-2] = "-2",
			[2] = "2",
			[3] = "3",
		})).toEqual(false)
	end)

	it("returns true for valid arrays", function()
		jestExpect(isArray({ "a", "b", "c" })).toEqual(true)
		jestExpect(isArray({ 1, 2, 3 })).toEqual(true)
		jestExpect(isArray({ 1, "b", function() end } :: Array<any>)).toEqual(true)
	end)
end
