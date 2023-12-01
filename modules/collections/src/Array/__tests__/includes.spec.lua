-- Tests partially based on examples from:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes
return function()
	local includes = require("../includes")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	local beasts = { "ant", "bison", "camel", "duck", "bison" }

	it("finds an element", function()
		jestExpect(includes(beasts, "bison")).toBe(true)
	end)

	it("does not find element when index after its position is provided", function()
		jestExpect(includes(beasts, "ant", 3)).toBe(false)
	end)

	it("returns false when the fromIndex is too large", function()
		jestExpect(includes(beasts, "camel", 6)).toBe(false)
	end)

	it("accepts a negative fromIndex, and subtracts it from the total length", function()
		jestExpect(includes(beasts, "duck", -1)).toBe(true)
		jestExpect(includes(beasts, "camel", -2)).toBe(true)
		jestExpect(includes(beasts, "camel", -1)).toBe(false)
	end)

	it("accepts a 0 fromIndex (special case for Lua's 1-index arrays) and starts at the end", function()
		jestExpect(includes(beasts, "bison", 0)).toEqual(true)
	end)

	it("starts at the beginning when it receives a too-large negative fromIndex", function()
		jestExpect(includes(beasts, "bison", -10)).toBe(true)
		jestExpect(includes(beasts, "ant", -10)).toBe(true)
	end)
end
