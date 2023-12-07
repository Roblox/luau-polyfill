-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/shift
return function()
	local __DEV__ = _G.__DEV__
	local shift = require("../shift")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("shifts three element array", function()
		local array1 = { 1, 2, 3 }

		local firstElement = shift(array1)
		jestExpect(array1).toEqual({ 2, 3 })
		jestExpect(firstElement).toEqual(1)
	end)

	it("removes an element from an array", function()
		local myFish = { "angel", "clown", "mandarin", "surgeon" }

		local shifted = shift(myFish)
		jestExpect(myFish).toEqual({ "clown", "mandarin", "surgeon" })
		jestExpect(shifted).toEqual("angel")
	end)

	it("shifts in a loop", function()
		local names = { "Andrew", "Edward", "Paul", "Chris", "John" }
		local nameString = ""
		local name = shift(names)

		while name do
			nameString = nameString .. " " .. name
			name = shift(names)
		end

		jestExpect(nameString).toEqual(" Andrew Edward Paul Chris John")
	end)

	it("shifts empty array", function()
		local empty = {}
		local none = shift(empty)

		jestExpect(empty).toEqual({})
		jestExpect(none).toEqual(nil)
	end)

	if __DEV__ then
		it("throws error on non-array", function()
			local nonarr = "abc"
			-- work around type checking on arguments
			local shift_: any = shift :: any
			jestExpect(function()
				shift_(nonarr)
			end).toThrow("Array.shift called on non-array string")
		end)
	end
end
