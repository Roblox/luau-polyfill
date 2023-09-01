return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local reverse = require(Array.reverse)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns the same array", function()
		local array = {}
		jestExpect(reverse(array)).toBe(array)
	end)

	it("reverses the members", function()
		local numbers = { 4, 5, 10, 88 }
		reverse(numbers)
		jestExpect(numbers).toEqual({ 88, 10, 5, 4 })
	end)
end
