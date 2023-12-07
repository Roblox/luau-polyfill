return function()
	local toExponential = require("../toExponential")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	describe("returns nil for invalid input", function()
		-- Luau FIXME: Windows returns "nan", but Linux returns "-nan"
		itSKIP("toExponential(nil)", function()
			jestExpect(toExponential(nil :: any)).toEqual("nan")
		end)

		itSKIP("toExponential('abcd')", function()
			jestExpect(toExponential("abcd" :: any)).toEqual("nan")
		end)
	end)

	describe("throws for invalid values of fractionDigits", function()
		it("toExponential(77.1234, -1)", function()
			jestExpect(function()
				toExponential(77.1234, -1)
			end).toThrow()
		end)

		it("toExponential(77.1234, 101)", function()
			jestExpect(function()
				toExponential(77.1234, 101)
			end).toThrow()
		end)

		it("toExponential(77.1234, 'abcd')", function()
			jestExpect(function()
				toExponential(77.1234, "abcd" :: any)
			end).toThrow()
		end)
	end)

	it("toExponential(77.1234)", function()
		jestExpect(toExponential(77.1234)).toEqual("7.71234e+1")
	end)

	it("toExponential(77.1234, 0)", function()
		jestExpect(toExponential(77.1234, 0)).toEqual("8e+1")
	end)

	it("toExponential(77.1234, 2)", function()
		jestExpect(toExponential(77.1234, 2)).toEqual("7.71e+1")
	end)

	it("toExponential(77.1234, 4)", function()
		jestExpect(toExponential(77.1234, 4)).toEqual("7.7123e+1")
	end)

	it("toExponential('77.1234')", function()
		jestExpect(toExponential(77.1234)).toEqual("7.71234e+1")
	end)

	it("toExponential(77)", function()
		jestExpect(toExponential(77)).toEqual("7.7e+1")
	end)
end
