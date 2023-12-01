return function()
	local split = require("../split")
	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

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
		jestExpect(split(str, { "\r\n", "\r", "\n" })).toEqual({
			"one",
			"two",
			"three",
			"four",
		})
	end)

	it("should include empty string in the beginning", function()
		local str = "babc"
		jestExpect(split(str, { "b" })).toEqual({ "", "a", "c" })
	end)

	it("should include empty string in the end", function()
		local str = "abcb"
		jestExpect(split(str, { "b" })).toEqual({ "a", "c", "" })
	end)

	it("should not interpret Lua pattern matching characters", function()
		local str = "a.b.c"
		jestExpect(split(str, ".")).toEqual({ "a", "b", "c" })
		str = "a%b%c"
		jestExpect(split(str, "%")).toEqual({ "a", "b", "c" })
	end)

	it("should include whole string if no match", function()
		local str = "abc"
		jestExpect(split(str, { "d" })).toEqual({ "abc" })
	end)

	it("should include whole string if pattern is nil", function()
		local str = "abc"
		jestExpect(split(str, nil)).toEqual({ "abc" })
	end)

	it("should include whole string if pattern is an empty string", function()
		local str = "abc"
		jestExpect(split(str, "")).toEqual({ "a", "b", "c" })
	end)

	it("should split the string containing multi-byte character", function()
		local str = '\u{FEFF}|# "Comment" string\n,|'
		local spl = split(str, { "\r\n", "\n", "\r" })
		jestExpect(spl).toEqual({
			'\u{FEFF}|# "Comment" string',
			",|",
		})
	end)

	it("should return no splits when limit is 0", function()
		local str = "And then Bob is your Uncle"
		local spl = split(str, " ", 0)
		jestExpect(spl).toEqual({})
	end)

	it("should return one split when limit is 1", function()
		local str = "And then Bob is your Uncle"
		local spl = split(str, " ", 1)
		jestExpect(spl).toEqual({
			"And",
		})
	end)

	it("should return a limited number of splits", function()
		local str = "And then Bob is your Uncle"
		local spl = split(str, " ", 3)
		jestExpect(spl).toEqual({
			"And",
			"then",
			"Bob",
		})
	end)

	it("should return all splits when limit is negative", function()
		local str = "And then Bob is your Uncle"
		local spl = split(str, " ", -1)
		jestExpect(spl).toEqual({
			"And",
			"then",
			"Bob",
			"is",
			"your",
			"Uncle",
		})
	end)
end
