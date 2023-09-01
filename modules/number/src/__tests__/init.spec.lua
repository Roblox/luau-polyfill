return function()
	local NumberModule = script.Parent.Parent
	local Number = require(NumberModule)

	local Packages = NumberModule.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("has MAX_SAFE_INTEGER constant", function()
		jestExpect(Number.MAX_SAFE_INTEGER).toEqual(jestExpect.any("number"))
	end)

	it("has MIN_SAFE_INTEGER constant", function()
		jestExpect(Number.MIN_SAFE_INTEGER).toEqual(jestExpect.any("number"))
	end)
end
