return function()
	local String = script.Parent.Parent
	local Packages = String.Parent.Parent
	local slice = require(String.slice)
	local JestRoblox = require(Packages.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	it("returns a sliced string", function()
		local str = "hello"
		jestExpect(slice(str, 2, 4)).toEqual("el")
		jestExpect(slice(str, 3)).toEqual("llo")
	end)

	it("returns a sliced string if start is below zero", function()
		local str = "hello"
		jestExpect(slice(str, -1)).toEqual("o")
		jestExpect(slice(str, -2)).toEqual("lo")
		jestExpect(slice(str, -3)).toEqual("llo")
		jestExpect(slice(str, -4)).toEqual("ello")
		jestExpect(slice(str, -5)).toEqual("hello")
		jestExpect(slice(str, -6)).toEqual("hello")
		jestExpect(slice(str, -100)).toEqual("hello")
	end)

	it("returns empty string when start index is below zero", function()
		local str = "4.123"
		jestExpect(slice(str, -1, 4)).toEqual("")
	end)

	it("returns correct substring when start index is zero", function()
		local str = "4.123"
		jestExpect(slice(str, 0, 4)).toEqual("4.1")
	end)

	it("returns correct substring when start index is one", function()
		local str = "4.123"
		jestExpect(slice(str, 1, 4)).toEqual("4.1")
	end)

	it("retruns empty string when start position is greater than str length", function()
		local str = "4.123"
		jestExpect(slice(str, 7, 4)).toEqual("")
	end)

	it("retruns full string when end position undefined", function()
		local str = "4.123"
		jestExpect(slice(str, 1)).toEqual("4.123")
	end)

	it("retruns full string when end position is greater than str length", function()
		local str = "4.123"
		jestExpect(slice(str, 1, 99)).toEqual("4.123")
	end)

	it("handle chars above 7-bit ascii", function()
		-- two bytes
		-- first byte (81)  - has high bit set
		-- second byte (23) - must have second byte
		local body = "\u{8123}a"

		jestExpect(slice(body, 1, 2)).toEqual("\u{8123}")
		jestExpect(slice(body, 2, 3)).toEqual("a")

		body = "123 \u{0A0A} 456"

		jestExpect(slice(body, 1, 6)).toEqual("123 \u{0A0A}")
		jestExpect(slice(body, 5, 10)).toEqual("\u{0A0A} 456")
	end)
end
