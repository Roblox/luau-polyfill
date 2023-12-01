return function()
	local MAX_SAFE_INTEGER = require("../MAX_SAFE_INTEGER")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	it("is not equal to the next bigger integer", function()
		jestExpect(MAX_SAFE_INTEGER).never.toEqual(MAX_SAFE_INTEGER + 1)
	end)

	it("is the biggest integer possible", function()
		local unsafeInteger = MAX_SAFE_INTEGER + 1
		jestExpect(unsafeInteger).toEqual(unsafeInteger + 1)
	end)
end
