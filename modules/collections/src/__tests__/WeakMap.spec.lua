return function()
	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
	local jestExpect = JestGlobals.expect

	local WeakMap = require("../WeakMap")

	describe("WeakMap", function()
		it("should be imported", function()
			jestExpect(WeakMap).toBeDefined()
		end)

		it("should create a new WeakMap", function()
			local weakMap: any = WeakMap.new()
			jestExpect(weakMap).toBeInstanceOf(WeakMap)
		end)

		it("should set and get", function()
			local weakMap: any = WeakMap.new()
			local table = {}
			local fn = function() end
			weakMap:set(1, "one")
			weakMap:set(2, "two")
			weakMap:set("apple", "red")
			weakMap:set(table, "table")
			weakMap:set(fn, "fn")
			jestExpect(weakMap:get(1)).toBe("one")
			jestExpect(weakMap:get(2)).toBe("two")
			jestExpect(weakMap:get("apple")).toBe("red")
			jestExpect(weakMap:get(table)).toBe("table")
			jestExpect(weakMap:get(fn)).toBe("fn")
		end)

		it("should properly handle keys 'get' and 'set'", function()
			local weakMap: any = WeakMap.new()
			weakMap:set("set", "setValue")
			weakMap:set("get", "getValue")
			jestExpect(weakMap:get("set")).toBe("setValue")
			jestExpect(weakMap:get("get")).toBe("getValue")
		end)

		describe("has", function()
			it("returns true if the item is in the Map", function()
				local foo = WeakMap.new()
				foo:set("bar", "foo")
				jestExpect(foo:has("bar")).toEqual(true)
			end)

			it("returns false if the item is not in the Map", function()
				local foo = WeakMap.new()
				jestExpect(foo:has("bar")).toEqual(false)
			end)

			it("returns correctly with value set to false", function()
				local foo = WeakMap.new()
				foo:set("bar", "false")
				jestExpect(foo:has("bar")).toEqual(true)
			end)
		end)
	end)
end
