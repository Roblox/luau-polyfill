return function()
	local Object = script.Parent.Parent
	local None = require(Object.None)

	local assign = require(Object.assign)

	local LuauPolyfill = Object.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
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
		}

		assign(target, source1, source2)

		jestExpect(target).toEqual({ a = 5, b = source2.b, c = source1.c })
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

	it("should ignore non-table arguments", function()
		local target = {
			foo = 1,
		}

		local source1 = {
			foo = 2,
			bar = 1,
		}

		assign(target, nil, true, 1, source1)

		jestExpect(target).toEqual({ foo = 2, bar = 1 })
	end)
end
