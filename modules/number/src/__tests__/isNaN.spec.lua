return function()
	local isNaN = require("../isNaN")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns true when given 0/0", function()
		jestExpect(isNaN(0 / 0)).toEqual(true)
	end)

	it('returns false when given "nan"', function()
		jestExpect(isNaN("nan")).toEqual(false)
	end)

	it("returns false when given nil", function()
		jestExpect(isNaN(nil)).toEqual(false)
	end)

	it("returns false when given {}", function()
		jestExpect(isNaN({})).toEqual(false)
	end)

	it('returns false when given "blabla"', function()
		jestExpect(isNaN("blabla")).toEqual(false)
	end)

	it("returns false when given true", function()
		jestExpect(isNaN(true)).toEqual(false)
	end)

	it("returns false when given 37", function()
		jestExpect(isNaN(37)).toEqual(false)
	end)

	it("returns false when given an empty string", function()
		jestExpect(isNaN("")).toEqual(false)
	end)
end
