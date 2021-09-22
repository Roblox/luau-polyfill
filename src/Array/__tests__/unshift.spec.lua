-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/ununshift
return function()
	local Array = script.Parent.Parent
	local LuauPolyfill = Array.Parent
	local unshift = require(Array.unshift)

	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("unshifts multi-element array with multiple elements", function()
		local array1 = { 1, 2, 3 }

		local newLength = unshift(array1, 4, 5)
		jestExpect(array1).toEqual({ 4, 5, 1, 2, 3 })
		jestExpect(newLength).toEqual(5)
	end)

	it("unshifts multi-element array with no elements", function()
		local array1 = { 1, 2, 3 }

		local newLength = unshift(array1)
		jestExpect(array1).toEqual({ 1, 2, 3 })
		jestExpect(newLength).toEqual(3)
	end)

	it("unshifts empty array with multiple elements", function()
		local empty = {}
		local newLength = unshift(empty, 1, 2)

		jestExpect(empty).toEqual({ 1, 2 })
		jestExpect(newLength).toEqual(2)
	end)

	it("unshifts empty array with no elements", function()
		local empty = {}
		local newLength = unshift(empty)

		jestExpect(empty).toEqual({})
		jestExpect(newLength).toEqual(0)
	end)

	if _G.__DEV__ then
		it("throws error on non-array", function()
			local nonarr = "abc"
			-- work around type checking on arguments
			local unshift_: any = unshift :: any
			jestExpect(function()
				unshift_(nonarr)
			end).toThrow("Array.unshift called on non-array string")
		end)
	end
end
