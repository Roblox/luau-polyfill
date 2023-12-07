-- unit tests based on MDN examples: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/lastIndexOf
return function()
	local lastIndexOf = require("../lastIndexOf")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns -1 when character is not found", function()
		jestExpect(lastIndexOf("canal", "x")).toEqual(-1)
	end)

	it("returns last index of found character when no fromIndex is present", function()
		jestExpect(lastIndexOf("canal", "a")).toEqual(4)
	end)

	it("returns last index of found character when fromIndex is present", function()
		jestExpect(lastIndexOf("canal", "a", 2)).toEqual(2)
		jestExpect(lastIndexOf("canal", "c", 1)).toEqual(1)
	end)

	it("return last index of character when fromIndex is greater than the length", function()
		jestExpect(lastIndexOf("canal", "a", 999999)).toEqual(4)
	end)

	it("treats fromIndex as 1 when fromIndex is less than 1", function()
		jestExpect(lastIndexOf("canal", "a", -999999)).toEqual(-1)
		jestExpect(lastIndexOf("canal", "c", -999999)).toEqual(1)
		jestExpect(lastIndexOf("canal", "c", 0)).toEqual(1)
	end)

	it("returns lastFromIndex or string length if the searchValue is empty string", function()
		jestExpect(lastIndexOf("foo", "")).toEqual(string.len("foo"))
		jestExpect(lastIndexOf("foo", "", 2)).toEqual(2)
		jestExpect(lastIndexOf("foo", "", -10)).toEqual(1)
	end)

	it("fromIndex limits only the beginning of the match", function()
		jestExpect(lastIndexOf("abab", "ab")).toEqual(3)
		jestExpect(lastIndexOf("abab", "ab", 3)).toEqual(3)
	end)
end
