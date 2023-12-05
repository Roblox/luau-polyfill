return function()
	local isSafeInteger = require("../isSafeInteger")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns true when given 3", function()
		jestExpect(isSafeInteger(3)).toEqual(true)
	end)

	it("returns true when given math.pow(2, 53) - 1", function()
		jestExpect(isSafeInteger(math.pow(2, 53) - 1)).toEqual(true)
	end)

	it("returns true when given 3.0", function()
		jestExpect(isSafeInteger(3.0)).toEqual(true)
	end)

	it("returns false when given math.pow(2, 53)", function()
		jestExpect(isSafeInteger(math.pow(2, 53))).toEqual(false)
	end)

	it("returns false when given nan", function()
		jestExpect(isSafeInteger(0 / 0)).toEqual(false)
	end)

	it("returns false when given inf", function()
		jestExpect(isSafeInteger(math.huge)).toEqual(false)
	end)

	it("returns false when given '3'", function()
		jestExpect(isSafeInteger("3" :: any)).toEqual(false)
	end)

	it("returns false when given 3.1", function()
		jestExpect(isSafeInteger(3.1)).toEqual(false)
	end)
end
