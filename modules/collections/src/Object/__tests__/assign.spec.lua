--!strict
return function()
	local assign = require("../assign")
	local None = require("../None")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	it("should accept zero additional tables", function()
		local input = {}
		local result = assign(input)

		jestExpect(input).toEqual(result)
	end)

	it("should merge multiple tables onto the given target table", function()
		local target = {
			a = 5,
			b = 6,
		}

		local source1 = {
			b = 7,
			c = 8,
		}

		local source2 = {
			b = 8,
			c = "hello",
		}

		local _target2 = assign(target, source1, source2)
		-- _target2.c = "hello" -- errors, `c` included in source1 as number and source2 as string, so c ends up being number & string

		local _target3 = assign(target, source1)
		-- _target3.c = "hello" -- errors, `c` included in source1 as number

		local target4 = assign(target, source2)
		target4.c = "hello!" -- doesn't error, `c` not included in target or source2

		jestExpect(target).toEqual({ a = 5, b = source2.b, c = target4.c })
		target.c = "goodbye" -- doesn't error, `c` not included in target, and Luau doesn't express type side-effects, intersection only affects return value
	end)

	it("should remove keys if specified as None", function()
		local target = {
			foo = 2,
			bar = 3,
		}

		local source = {
			foo = None,
		}

		assign(target, source)

		jestExpect(target.foo).toEqual(nil)
		jestExpect(target.bar).toEqual(3)
	end)

	it("should re-add keys if specified after None", function()
		local target = {
			foo = 2,
		}

		local source1 = {
			foo = None,
		}

		local source2 = {
			foo = 3,
		}

		assign(target, source1, source2)

		jestExpect(target.foo).toEqual(source2.foo)
	end)

	it("should assign from more than 5 tables", function()
		local target = {
			foo = 0,
		}

		local source1 = {
			foo = 1,
		}

		local source2 = {
			foo = 2,
		}

		local source3 = {
			foo = 3,
		}

		local source4 = {
			foo = 4,
		}

		local source5 = {
			foo = 5,
		}

		local source6 = {
			foo = None,
		}

		assign(target, source1, source2, source3, source4, source5, source6)

		jestExpect(target).toEqual({})
	end)

	it("should ignore non-table arguments", function()
		local target = {
			foo = 1,
		}

		local source1 = {
			foo = 2,
			bar = 1,
		};

		(assign :: any)(target, nil, true, 1, source1)

		jestExpect(target).toEqual({ foo = 2, bar = 1 })
	end)
end
