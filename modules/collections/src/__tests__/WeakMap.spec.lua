--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
return function()
	local root = script.Parent.Parent
	local Packages = root.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local WeakMap = require(root.WeakMap)

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
