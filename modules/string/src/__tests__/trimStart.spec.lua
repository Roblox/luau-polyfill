return function()
	local trimStart = require("../trimStart")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	it("removes spaces at beginning", function()
		jestExpect(trimStart("  abc")).toEqual("abc")
	end)

	it("does not remove spaces at end", function()
		jestExpect(trimStart("abc   ")).toEqual("abc   ")
	end)

	it("removes spaces at only at beginning", function()
		jestExpect(trimStart("  abc   ")).toEqual("abc   ")
	end)

	it("does not remove spaces in the middle", function()
		jestExpect(trimStart("a b c")).toEqual("a b c")
	end)

	it("removes all types of spaces", function()
		jestExpect(trimStart("\r\n\t\f\vabc")).toEqual("abc")
	end)

	it("returns an empty string if there are only spaces", function()
		jestExpect(trimStart("    ")).toEqual("")
	end)
end
