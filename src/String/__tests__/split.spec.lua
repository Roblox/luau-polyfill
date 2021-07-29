return function()
	local String = script.Parent.Parent
	local Packages = String.Parent.Parent
	local split = require(String.split)
	local JestRoblox = require(Packages.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	it("should split with single split pattern", function()
		local str = "The quick brown fox jumps over the lazy dog."
		jestExpect(split(str, " ")).toEqual({
			"The",
			"quick",
			"brown",
			"fox",
			"jumps",
			"over",
			"the",
			"lazy",
			"dog.",
		})
	end)

	it("should split with table with single split pattern", function()
		local str = "The quick brown fox jumps over the lazy dog."
		jestExpect(split(str, { " " })).toEqual({
			"The",
			"quick",
			"brown",
			"fox",
			"jumps",
			"over",
			"the",
			"lazy",
			"dog.",
		})
	end)

	it("should split with table with multiple split pattern", function()
		local str = "one\ntwo\rthree\r\nfour"
		jestExpect(split(str, { "\r\n", "\r", "\n" })).toEqual({ "one", "two", "three", "four" })
	end)

	it("should include empty string in the beginning", function()
		local str = "babc"
		jestExpect(split(str, { "b" })).toEqual({ "", "a", "c" })
	end)

	it("should include empty string in the end", function()
		local str = "abcb"
		jestExpect(split(str, { "b" })).toEqual({ "a", "c", "" })
	end)

	it("should include whole string if no match", function()
		local str = "abc"
		jestExpect(split(str, { "d" })).toEqual({ "abc" })
	end)

	it("should include whole string if pattern is nil", function()
		local str = "abc"
		jestExpect(split(str)).toEqual({ "abc" })
	end)

	it("should include whole string if pattern is an empty string", function()
		local str = "abc"
		jestExpect(split(str)).toEqual({ "abc" })
	end)

	it('should split the string containing multi-byte character', function()
		local str = '\u{FEFF}|# "Comment" string\n,|'
		local spl = split(str, { "\r\n", "\n", "\r" })
		jestExpect(spl).toEqual({
			'\u{FEFF}|# "Comment" string', ',|'
		})
	end)
end
