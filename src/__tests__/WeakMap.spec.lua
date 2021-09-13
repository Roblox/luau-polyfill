return function()
	local LuauPolyfill = script.Parent.Parent

	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local WeakMap = require(LuauPolyfill.WeakMap)

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
	end)
end
