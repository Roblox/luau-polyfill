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
--!strict
return function()
	local __DEV__ = _G.__DEV__
	local MapModule = script.Parent.Parent
	local Collections = MapModule.Parent
	local Packages = Collections.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	local Array = require(Collections.Array)
	local types = require(Packages.ES7Types)
	local instanceOf = require(Packages.InstanceOf)

	local Map = require(MapModule.Map)
	local coerceToMap = require(MapModule.coerceToMap)
	local coerceToTable = require(MapModule.coerceToTable)

	type Function = types.Function
	type Map<K, V> = types.Map<K, V>
	type Object = types.Object

	local AN_ITEM = "bar"
	local ANOTHER_ITEM = "baz"

	describe("Map", function()
		describe("constructors", function()
			it("creates an empty array", function()
				local foo = Map.new()
				jestExpect(foo.size).toEqual(0)
			end)

			it("creates a Map from an array", function()
				local foo = Map.new({
					{ AN_ITEM, "foo" },
					{ ANOTHER_ITEM, "val" },
				})
				jestExpect(foo.size).toEqual(2)
				jestExpect(foo:has(AN_ITEM)).toEqual(true)
				jestExpect(foo:has(ANOTHER_ITEM)).toEqual(true)
			end)

			it("errors when not given an Array of array", function()
				if __DEV__ then
					jestExpect(function()
						-- types don't permit this abuse, so cast away safety
						(Map.new :: any)({ AN_ITEM, "foo" })
					end).toThrow("cannot create Map")
					jestExpect(function()
						(Map.new :: any)({
							{ AN_ITEM = "foo" },
						})
					end).toThrow("cannot create Map")
				end
			end)

			it("creates a Map from an array with duplicate keys", function()
				local foo = Map.new({
					{ AN_ITEM, "foo1" },
					{ AN_ITEM, "foo2" },
				})
				jestExpect(foo.size).toEqual(1)
				jestExpect(foo:get(AN_ITEM)).toEqual("foo2")

				jestExpect(foo:keys()).toEqual({ AN_ITEM })
				jestExpect(foo:values()).toEqual({ "foo2" })
				jestExpect(foo:entries()).toEqual({ { AN_ITEM, "foo2" } })
			end)

			it("preserves the order of keys first assignment", function()
				local foo = Map.new({
					{ AN_ITEM, "foo1" },
					{ ANOTHER_ITEM, "bar" },
					{ AN_ITEM, "foo2" },
				})
				jestExpect(foo.size).toEqual(2)
				jestExpect(foo:get(AN_ITEM)).toEqual("foo2")
				jestExpect(foo:get(ANOTHER_ITEM)).toEqual("bar")

				jestExpect(foo:keys()).toEqual({ AN_ITEM, ANOTHER_ITEM })
				jestExpect(foo:values()).toEqual({ "foo2", "bar" })
				jestExpect(foo:entries()).toEqual({
					{ AN_ITEM, "foo2" },
					{ ANOTHER_ITEM, "bar" },
				})
			end)

			it("throws when trying to create a set from a non-iterable", function()
				if __DEV__ then
					jestExpect(function()
						return (Map.new :: any)(true)
					end).toThrow("cannot create array from value of type `boolean`")
					jestExpect(function()
						return (Map.new :: any)(1)
					end).toThrow("cannot create array from value of type `number`")
				end
			end)
		end)

		describe("type", function()
			it("instanceOf return true for an actual Map object", function()
				local foo = Map.new()
				jestExpect(instanceOf(foo, Map)).toEqual(true)
			end)

			it("instanceOf return false for an regular plain object", function()
				local foo = {}
				jestExpect(instanceOf(foo, Map)).toEqual(false)
			end)
		end)

		describe("set", function()
			it("returns the Map object", function()
				local foo = Map.new()
				jestExpect(foo:set(1, "baz")).toEqual(foo)
			end)

			it("increments the size if the element is added for the first time", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				jestExpect(foo.size).toEqual(1)
			end)

			it("does not increment the size the second time an element is added", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(AN_ITEM, "val")
				jestExpect(foo.size).toEqual(1)
			end)

			it("sets values correctly to true/false", function()
				-- Luau FIXME: Luau insists that arrays can't be mixed type
				local foo = Map.new({ { AN_ITEM, false :: any } })
				foo:set(AN_ITEM, false)
				jestExpect(foo.size).toEqual(1)
				jestExpect(foo:get(AN_ITEM)).toEqual(false)

				foo:set(AN_ITEM, true)
				jestExpect(foo.size).toEqual(1)
				jestExpect(foo:get(AN_ITEM)).toEqual(true)

				foo:set(AN_ITEM, false)
				jestExpect(foo.size).toEqual(1)
				jestExpect(foo:get(AN_ITEM)).toEqual(false)
			end)
		end)

		describe("get", function()
			it("returns value of item from provided key", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				jestExpect(foo:get(AN_ITEM)).toEqual("foo")
			end)

			it("returns nil if the item is not in the Map", function()
				local foo = Map.new()
				jestExpect(foo:get(AN_ITEM)).toEqual(nil)
			end)
		end)

		describe("clear", function()
			it("sets the size to zero", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:clear()
				jestExpect(foo.size).toEqual(0)
			end)

			it("removes the items from the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:clear()
				jestExpect(foo:has(AN_ITEM)).toEqual(false)
			end)
		end)

		describe("delete", function()
			it("removes the items from the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:delete(AN_ITEM)
				jestExpect(foo:has(AN_ITEM)).toEqual(false)
			end)

			it("returns true if the item was in the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				jestExpect(foo:delete(AN_ITEM)).toEqual(true)
			end)

			it("returns false if the item was not in the Map", function()
				local foo = Map.new()
				jestExpect(foo:delete(AN_ITEM)).toEqual(false)
			end)

			it("decrements the size if the item was in the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:delete(AN_ITEM)
				jestExpect(foo.size).toEqual(0)
			end)

			it("does not decrement the size if the item was not in the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:delete(ANOTHER_ITEM)
				jestExpect(foo.size).toEqual(1)
			end)

			it("deletes value set to false", function()
				-- Luau FIXME: Luau insists arrays can't be mixed type
				local foo = Map.new({ { AN_ITEM, false :: any } })

				foo:delete(AN_ITEM)

				jestExpect(foo.size).toEqual(0)
				jestExpect(foo:get(AN_ITEM)).toEqual(nil)
			end)
		end)

		describe("has", function()
			it("returns true if the item is in the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				jestExpect(foo:has(AN_ITEM)).toEqual(true)
			end)

			it("returns false if the item is not in the Map", function()
				local foo = Map.new()
				jestExpect(foo:has(AN_ITEM)).toEqual(false)
			end)

			it("returns correctly with value set to false", function()
				-- Luau FIXME: Luau insists arrays can't be mixed type
				local foo = Map.new({ { AN_ITEM, false :: any } })

				jestExpect(foo:has(AN_ITEM)).toEqual(true)
			end)
		end)

		describe("keys / values / entries", function()
			it("returns array of elements", function()
				local myMap = Map.new()
				myMap:set(AN_ITEM, "foo")
				myMap:set(ANOTHER_ITEM, "val")

				jestExpect(myMap:keys()).toEqual({ AN_ITEM, ANOTHER_ITEM })
				jestExpect(myMap:values()).toEqual({ "foo", "val" })
				jestExpect(myMap:entries()).toEqual({
					{ AN_ITEM, "foo" },
					{ ANOTHER_ITEM, "val" },
				})
			end)
		end)

		describe("__index", function()
			it("can access fields directly without using get", function()
				local typeName = "size"

				local foo = Map.new({
					{ AN_ITEM, "foo" },
					{ ANOTHER_ITEM, "val" },
					{ typeName, "buzz" },
				})

				jestExpect(foo.size).toEqual(3)
				jestExpect(foo[AN_ITEM]).toEqual("foo")
				jestExpect(foo[ANOTHER_ITEM]).toEqual("val")
				jestExpect(foo:get(typeName)).toEqual("buzz")
			end)

			if __DEV__ then
				it("errors when indexing a Map that's been incorrectly passed to table.clear()", function()
					local foo = Map.new({
						{ AN_ITEM, "foo" },
					})

					table.clear(foo)

					jestExpect(function()
						return foo.size
					end).toThrow("corrupted")
					jestExpect(function()
						return foo[AN_ITEM]
					end).toThrow("corrupted")
				end)
			end
		end)

		describe("__newindex", function()
			it("can set fields directly without using set", function()
				local foo = Map.new()

				jestExpect(foo.size).toEqual(0)

				foo[AN_ITEM] = "foo"
				foo[ANOTHER_ITEM] = "val"
				foo.fizz = "buzz"

				jestExpect(foo.size).toEqual(3)
				jestExpect(foo:get(AN_ITEM)).toEqual("foo")
				jestExpect(foo:get(ANOTHER_ITEM)).toEqual("val")
				jestExpect(foo:get("fizz")).toEqual("buzz")
			end)
		end)

		describe("iter", function()
			local function makeArray(...)
				local array = {}
				for _, item in ... do
					table.insert(array, item)
				end
				return array
			end

			it("iterates on an empty set", function()
				local foo = Map.new()
				for k, v in foo do
					error("should not iterate on empty set")
				end
				jestExpect(makeArray(foo)).toEqual({})
			end)

			it("iterates on the elements by their insertion order", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(ANOTHER_ITEM, "val")
				jestExpect(makeArray(foo)).toEqual({
					{ AN_ITEM, "foo" },
					{ ANOTHER_ITEM, "val" },
				})
			end)

			it("does not iterate on removed elements", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(ANOTHER_ITEM, "val")
				foo:delete(AN_ITEM)
				jestExpect(makeArray(foo)).toEqual({
					{ ANOTHER_ITEM, "val" },
				})
			end)

			it("iterates on elements if the added back to the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(ANOTHER_ITEM, "val")
				foo:delete(AN_ITEM)
				foo:set(AN_ITEM, "food")
				jestExpect(makeArray(foo)).toEqual({
					{ ANOTHER_ITEM, "val" },
					{ AN_ITEM, "food" },
				})
			end)
		end)

		describe("Integration Tests", function()
			-- the following tests are adapted from the examples shown on the MDN documentation:
			-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map#examples
			it("MDN Examples", function()
				local myMap = Map.new() :: Map<string | Object | Function, string>

				local keyString = "a string"
				local keyObj = {}
				local keyFunc = function() end

				-- setting the values
				myMap:set(keyString, "value associated with 'a string'")
				myMap:set(keyObj, "value associated with keyObj")
				myMap:set(keyFunc, "value associated with keyFunc")

				jestExpect(myMap.size).toEqual(3)

				-- getting the values
				jestExpect(myMap:get(keyString)).toEqual("value associated with 'a string'")
				jestExpect(myMap:get(keyObj)).toEqual("value associated with keyObj")
				jestExpect(myMap:get(keyFunc)).toEqual("value associated with keyFunc")

				jestExpect(myMap:get("a string")).toEqual("value associated with 'a string'")

				jestExpect(myMap:get({})).toEqual(nil) -- nil, because keyObj !== {}
				jestExpect(myMap:get(function() -- nil because keyFunc !== function () {}
				end)).toEqual(nil)
			end)

			it("handles non-traditional keys", function()
				local myMap = Map.new() :: Map<boolean | number | string, string>

				local falseKey = false
				local trueKey = true
				local negativeKey = -1
				local emptyKey = ""

				myMap:set(falseKey, "apple")
				myMap:set(trueKey, "bear")
				myMap:set(negativeKey, "corgi")
				myMap:set(emptyKey, "doge")

				jestExpect(myMap.size).toEqual(4)

				jestExpect(myMap:get(falseKey)).toEqual("apple")
				jestExpect(myMap:get(trueKey)).toEqual("bear")
				jestExpect(myMap:get(negativeKey)).toEqual("corgi")
				jestExpect(myMap:get(emptyKey)).toEqual("doge")

				myMap:delete(falseKey)
				myMap:delete(trueKey)
				myMap:delete(negativeKey)
				myMap:delete(emptyKey)

				jestExpect(myMap.size).toEqual(0)
			end)
		end)
	end)

	describe("coerceToMap", function()
		it("returns the same object if instance of Map", function()
			local map = Map.new()
			jestExpect(coerceToMap(map)).toEqual(map)

			map = Map.new({})
			jestExpect(coerceToMap(map)).toEqual(map)

			map = Map.new({ { AN_ITEM, "foo" } })
			jestExpect(coerceToMap(map)).toEqual(map)
		end)

		it("converts a table to a Map", function()
			local map = coerceToMap({})
			jestExpect(instanceOf(map, Map)).toEqual(true)
			jestExpect(map.size).toEqual(0)
			jestExpect(map:keys()).toEqual({})
			jestExpect(map:values()).toEqual({})
			jestExpect(map:entries()).toEqual({})

			map = coerceToMap({
				[AN_ITEM] = "foo",
				[ANOTHER_ITEM] = "val",
			})
			jestExpect(instanceOf(map, Map)).toEqual(true)
			jestExpect(map.size).toEqual(2)

			jestExpect(Array.sort(map:keys())).toEqual(Array.sort({ AN_ITEM, ANOTHER_ITEM }))
			jestExpect(Array.sort(map:values())).toEqual({ "foo", "val" })
			jestExpect(Array.sort(map:entries(), function(a, b)
				if tostring(a[1]) < tostring(b[1]) then
					return -1
				elseif tostring(a[1]) > tostring(b[1]) then
					return 1
				else
					return 0
				end
			end)).toEqual({
				{ AN_ITEM, "foo" },
				{ ANOTHER_ITEM, "val" },
			})
		end)
	end)

	describe("coerceToTable", function()
		it("converts a Map to a table", function()
			local map = Map.new()
			jestExpect(coerceToTable(map)).toEqual({})

			map = Map.new({})
			jestExpect(coerceToTable(map)).toEqual({})

			map = Map.new({ { AN_ITEM, "foo" } })
			jestExpect(coerceToTable(map)).toEqual({ [AN_ITEM] = "foo" })
		end)

		it("returns the same object if instance of table", function()
			local tbl = {}
			jestExpect(coerceToTable(tbl)).toEqual(tbl)

			tbl = {
				[AN_ITEM] = "foo",
				[ANOTHER_ITEM] = "val",
			}
			jestExpect(coerceToTable(tbl)).toEqual(tbl)
		end)
	end)

	describe("forEach", function()
		it("forEach a map of non-mixed keys and values", function()
			-- Luau FIXME: Luau insists arrays can't be mixed type
			local myMap: Map<number, string> = Map.new({ { 1, "one" :: any } })
			local mock = jest.fn()
			myMap:set(1, "one")
			myMap:set(2, "nil")
			myMap:set(3, "false")
			myMap:forEach(function(value: string, key: number)
				mock(value, 0 + key)
			end)
			jestExpect(mock).toHaveBeenCalledWith("one", 1)
			jestExpect(mock).toHaveBeenCalledWith("nil", 2)
			jestExpect(mock).toHaveBeenCalledWith("false", 3)
		end)

		it("forEach with 'this' argument", function()
			-- Luau FIXME: Luau insists arrays can't be mixed type
			local myMap: Map<number, string> = Map.new({ { 1, "one" :: any } })
			local mock = jest.fn()
			local obj = {
				message = "h0wdy",
			}
			myMap:forEach(function(self, value: string, key: number)
				mock(self.message, value, key)
			end, obj)
			jestExpect(mock).toHaveBeenCalledWith("h0wdy", "one", 1)
		end)

		it("forEach a map of mixed keys and values", function()
			local myMap = Map.new() :: Map<number | string, string | nil | boolean>
			local mock = jest.fn()
			myMap:set(1, "one")
			myMap:set(-2, nil)
			myMap:set("3", false)
			myMap:forEach(function(value, key)
				mock(value, key)
			end)
			jestExpect(mock).toHaveBeenCalledWith("one", 1)
			jestExpect(mock).toHaveBeenCalledWith(nil, -2)
			jestExpect(mock).toHaveBeenCalledWith(false, "3")
		end)

		it("forEach a map after a deletion", function()
			-- Luau FIXME: Luau insists arrays can't be mixed type
			local myMap: Map<number, string> = Map.new({ { 1, "one" :: any } })
			local mock = jest.fn()
			myMap:set(2, "nil")
			myMap:set(3, "false")
			myMap:delete(2)
			myMap:forEach(function(value, key)
				-- Luau knows key is number due to explicit Map<> annotation above
				mock(value, 0 + key)
			end)
			jestExpect(mock).toHaveBeenCalledWith("one", 1)
			jestExpect(mock).toHaveBeenCalledWith("false", 3)
		end)

		it("remove map element during forEach", function()
			-- Luau FIXME: Luau insists arrays can't be mixed type
			local myMap: Map<number, string> = Map.new({ { 1, "one" :: any } })
			local mock = jest.fn()
			myMap:set(2, "nil")
			myMap:set(3, "false")
			myMap:forEach(function(value, key)
				myMap:delete(2)
				-- Luau knows key is number due to explicit Map<> annotation above
				mock(value, 0 + key)
			end)
			jestExpect(mock).toHaveBeenCalledWith("one", 1)
			jestExpect(mock).toHaveBeenCalledWith("false", 3)
		end)

		it("add map element during forEach", function()
			-- Luau FIXME: Luau insists arrays can't be mixed type
			local myMap: Map<number, string> = Map.new({ { 1, "one" :: any } })
			local mock = jest.fn()
			myMap:set(2, "nil")
			myMap:set(3, "false")
			myMap:forEach(function(value, key)
				myMap:set(666, "beast")
				-- Luau knows key is number due to explicit Map<> annotation above
				mock(value, 0 + key)
			end)
			jestExpect(mock).toHaveBeenCalledWith("one", 1)
			jestExpect(mock).toHaveBeenCalledWith("nil", 2)
			jestExpect(mock).toHaveBeenCalledWith("false", 3)
			jestExpect(mock).never.toHaveBeenCalledWith(nil, nil)
			jestExpect(mock).never.toHaveBeenCalledWith("beast", 666)
		end)

		it("nested forEach", function()
			local mock = jest.fn()
			local kvArray = {
				-- Luau FIXME: Luau insists arrays can't be mixed type
				{ { key = 1 }, { value = 10 } :: any },
				{ { key = 2 }, { value = 20 } :: any },
				{ { key = 3 }, { value = 30 } :: any },
			}
			local myMap = Map.new({
				-- Luau FIXME: Luau insists arrays can't be mixed type
				{ "alice", Map.new(kvArray) :: any },
				{ "bob", Map.new() :: any },
			})
			myMap:forEach(function(value, key)
				value:forEach(function(value, key)
					mock(value, key)
				end)
			end)
			jestExpect(mock).toHaveBeenCalledWith({ value = 10 }, { key = 1 })
			jestExpect(mock).toHaveBeenCalledWith({ value = 20 }, { key = 2 })
			jestExpect(mock).toHaveBeenCalledWith({ value = 30 }, { key = 3 })
		end)
	end)
end
