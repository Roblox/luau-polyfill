return function()
	local Number = script.Parent.Parent
	local MIN_SAFE_INTEGER = require(Number.MIN_SAFE_INTEGER)

	local Packages = Number.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("is not equal to the next smaller integer", function()
		jestExpect(MIN_SAFE_INTEGER).never.toEqual(MIN_SAFE_INTEGER - 1)
	end)

	it("is the smallest integer possible", function()
		local unsafeInteger = MIN_SAFE_INTEGER - 1
		jestExpect(unsafeInteger).toEqual(unsafeInteger - 1)
	end)
end
