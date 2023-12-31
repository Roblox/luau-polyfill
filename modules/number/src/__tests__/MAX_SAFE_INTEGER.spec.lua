return function()
	local Number = script.Parent.Parent
	local MAX_SAFE_INTEGER = require(Number.MAX_SAFE_INTEGER)

	local Packages = Number.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("is not equal to the next bigger integer", function()
		jestExpect(MAX_SAFE_INTEGER).never.toEqual(MAX_SAFE_INTEGER + 1)
	end)

	it("is the biggest integer possible", function()
		local unsafeInteger = MAX_SAFE_INTEGER + 1
		jestExpect(unsafeInteger).toEqual(unsafeInteger + 1)
	end)
end
