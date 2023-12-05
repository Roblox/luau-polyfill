-- tests inspired by MDN documentation: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes
return function()
	local includes = require("../includes")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	local VALUE = "To be, or not to be, that is the question."

	it("returns true when substring is included", function()
		jestExpect(includes(VALUE, "To be")).toEqual(true)
		jestExpect(includes(VALUE, "question")).toEqual(true)
		jestExpect(includes(VALUE, "that", 5)).toEqual(true)
		jestExpect(includes(VALUE, "that", "5")).toEqual(true)
		jestExpect(includes(VALUE, "To be", 0)).toEqual(true)
		jestExpect(includes(VALUE, "To be", -1)).toEqual(true)
	end)

	it("returns false when substring is not included", function()
		jestExpect(includes(VALUE, "TO BE")).toEqual(false)
		jestExpect(includes(VALUE, "foo")).toEqual(false)
	end)

	it("returns false when position is beyond string length", function()
		jestExpect(includes(VALUE, "n", 999)).toEqual(false)
		jestExpect(includes(VALUE, ".", string.len(VALUE) + 1)).toEqual(false)
	end)
	it("returns true when position is exactly at string length", function()
		jestExpect(includes(VALUE, "n", string.len(VALUE) - 1)).toEqual(true)
		jestExpect(includes(VALUE, ".", string.len(VALUE))).toEqual(true)
	end)

	it("returns matched element when its a Lua pattern % character", function()
		local str = "a%c"
		local terms = "%"
		jestExpect(includes(str, terms)).toEqual(true)
	end)

	it("returns matched element when its a Lua pattern . character", function()
		local str = "a.c"
		local terms = "."
		jestExpect(includes(str, terms)).toEqual(true)
	end)

	it("returns true when substring is not after (1-indexed) start position", function()
		jestExpect(includes(VALUE, "To be", 1)).toEqual(true)
	end)

	it("returns false when substring is not after (1-indexed) start position", function()
		jestExpect(includes(VALUE, "To be", 4)).toEqual(false)
		jestExpect(includes(VALUE, "To be", 10000)).toEqual(false)
	end)

	it("returns true when substring is blank", function()
		jestExpect(includes(VALUE, "")).toEqual(true)
		jestExpect(includes(VALUE, "", -1)).toEqual(true)
		jestExpect(includes(VALUE, "", 99999)).toEqual(true)
	end)

	it("returns true when multi-byte character present in the source string", function()
		local str = "\u{FEFF}abbbc"
		local terms = "b"
		jestExpect(includes(str, terms)).toEqual(true)
	end)

	it("returns true after init index when multi-byte character present in the source string", function()
		local str = "\u{FEFF}ababc"
		local terms = "b"
		jestExpect(includes(str, terms, 4)).toEqual(true)
	end)

	it("escapes Lua patterns for raw matching", function()
		jestExpect(includes("something", "%w")).toEqual(false)
		jestExpect(includes("something%s", "%s")).toEqual(true)
	end)
end
