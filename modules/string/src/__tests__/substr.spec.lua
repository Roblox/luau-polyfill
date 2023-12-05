-- tests inspired by MDN documentation: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substr
return function()
	local substr = require("../substr")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("goes to end of string when number of characters is not supplied", function()
		jestExpect(substr("Roblox", 2)).toEqual("oblox")
	end)

	it("wraps to end of string when negative index is supplied", function()
		jestExpect(substr("Roblox", -1)).toEqual("x")
		jestExpect(substr("Roblox", -2)).toEqual("ox")
	end)

	it("captures only the correct characters when number of characters is supplied", function()
		jestExpect(substr("Roblox", 2, 2)).toEqual("ob")
	end)

	it("returns empty string when number of characters is less than 1", function()
		jestExpect(substr("Roblox", 2, 0)).toEqual("")
		jestExpect(substr("Roblox", 2, -2)).toEqual("")
	end)
end
