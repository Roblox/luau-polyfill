-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
return function()
	local is = require("../is")

	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	it("returns true when given ('foo', 'foo')", function()
		jestExpect(is("foo", "foo")).toEqual(true)
	end)

	it("returns false when given ('foo', 'bar')", function()
		jestExpect(is("foo", "bar")).toEqual(false)
	end)

	it("returns false when given ({}, {})", function()
		jestExpect(is({}, {})).toEqual(false)
	end)

	local foo = { a = 1 }
	local bar = { a = 1 }

	it("returns true when given (foo, foo)", function()
		jestExpect(is(foo, foo)).toEqual(true)
	end)

	it("returns false when given (foo, bar)", function()
		jestExpect(is(foo, bar)).toEqual(false)
	end)

	it("returns true when given (nil, nil)", function()
		jestExpect(is(nil, nil)).toEqual(true)
	end)

	it("returns false when given (0, -0)", function()
		jestExpect(is(0, -0)).toEqual(false)
	end)

	it("returns true when given (-0, -0)", function()
		jestExpect(is(-0, -0)).toEqual(true)
	end)

	it("returns true when given (0 / 0, 0 / 0)", function()
		jestExpect(is(0 / 0, 0 / 0)).toEqual(true)
	end)
end
