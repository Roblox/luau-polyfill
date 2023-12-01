return function()
	local values = require("../values")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns the values of a table", function()
		local result = values({
			foo = "bar",
			baz = "zoo",
		})
		table.sort(result)
		jestExpect(result).toEqual({ "bar", "zoo" })
	end)

	it("returns the values of an array-like table", function()
		local result = values({ "bar", "foo" })
		table.sort(result)
		jestExpect(result).toEqual({ "bar", "foo" })
	end)

	it("returns an array of character given a string", function()
		jestExpect(values("bar")).toEqual({ "b", "a", "r" })
	end)

	-- Luau types don't allow this to happen, figure out how to enable this test with type stripped
	itSKIP("throws given nil", function()
		jestExpect(function()
			-- values(nil)
		end).toThrow("cannot extract values from a nil value")
	end)
end
