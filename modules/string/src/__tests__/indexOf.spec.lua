-- Tests partially based on examples from:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/indexOf
return function()
	local indexOf = require("../indexOf")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns the fromIndex when search term is empty string", function()
		jestExpect(indexOf("hello world", "")).toEqual(1)
		jestExpect(indexOf("hello world", "", 1)).toEqual(1)
		jestExpect(indexOf("hello world", "", 3)).toEqual(3)
		jestExpect(indexOf("hello world", "", 6)).toEqual(6)
	end)

	it("returns the string length when search term is empty string and fromIndex > length", function()
		jestExpect(indexOf("hello world", "", 11)).toEqual(11)
		jestExpect(indexOf("hello world", "", 13)).toEqual(11)
		jestExpect(indexOf("hello world", "", 16)).toEqual(11)
	end)

	it("returns the index of the first occurrence of an element", function()
		jestExpect(indexOf("Blue Whale", "Blue")).toEqual(1)
	end)

	it("begins at the start index when provided", function()
		jestExpect(indexOf("Blue Whale", "Whale", 5)).toEqual(6)
	end)

	it("returns -1 when the value isn't present", function()
		jestExpect(indexOf("Blue Whale", "Blute")).toEqual(-1)
	end)

	it("returns -1 when the fromIndex is too large", function()
		jestExpect(indexOf("Blue Whale", "Blue", 16)).toEqual(-1)
	end)

	it("accepts a negative fromIndex", function()
		jestExpect(indexOf("Blue Whale", "Whale", -5)).toEqual(6)
	end)

	it("accepts a 0 fromIndex (special case for Lua's 1-index arrays) and starts at the beginning", function()
		jestExpect(indexOf("Blue Whale", "Whale", 0)).toEqual(6)
	end)
end
