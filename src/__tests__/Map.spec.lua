return function()
	local LuauPolyfill = script.Parent.Parent

	local Packages = LuauPolyfill.Parent
	local JestRoblox = require(Packages.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

    local Array = require(LuauPolyfill.Array)

	local MapModule = require(LuauPolyfill.Map)
	local Map = MapModule.Map
	local coerceToMap = MapModule.coerceToMap
	local coerceToTable = MapModule.coerceToTable
	local instanceOf = require(LuauPolyfill.instanceof)

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
				jestExpect(foo:entries()).toEqual({ { AN_ITEM, "foo2" }, { ANOTHER_ITEM, "bar" } })
			end)

			it("throws when trying to create a set from a non-iterable", function()
				jestExpect(function()
					return Map.new(true)
				end).toThrow("cannot create array from value of type `boolean`")
				jestExpect(function()
					return Map.new(1)
				end).toThrow("cannot create array from value of type `number`")
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
				jestExpect(foo:set(1)).toEqual(foo)
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
				local foo = Map.new({ { AN_ITEM, false } })
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
				local foo = Map.new({ { AN_ITEM, false } })

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
				local foo = Map.new({ { AN_ITEM, false } })

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

		describe("ipairs", function()
			local function makeArray(...)
				local array = {}
				for _, item in ... do
					table.insert(array, item)
				end
				return array
			end

			it("iterates on an empty set", function()
				local foo = Map.new()
				jestExpect(makeArray(foo:ipairs())).toEqual({})
			end)

			it("iterates on the elements by their insertion order", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(ANOTHER_ITEM, "val")
				jestExpect(makeArray(foo:ipairs())).toEqual({
					{ AN_ITEM, "foo" },
					{ ANOTHER_ITEM, "val" },
				})
			end)

			it("does not iterate on removed elements", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(ANOTHER_ITEM, "val")
				foo:delete(AN_ITEM)
				jestExpect(makeArray(foo:ipairs())).toEqual({ { ANOTHER_ITEM, "val" } })
			end)

			it("iterates on elements if the added back to the Map", function()
				local foo = Map.new()
				foo:set(AN_ITEM, "foo")
				foo:set(ANOTHER_ITEM, "val")
				foo:delete(AN_ITEM)
				foo:set(AN_ITEM, "food")
				jestExpect(makeArray(foo:ipairs())).toEqual({
					{ ANOTHER_ITEM, "val" },
					{ AN_ITEM, "food" },
				})
			end)
		end)

		describe("Integration Tests", function()
			-- the following tests are adapted from the examples shown on the MDN documentation:
			-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map#examples
			it("MDN Examples", function()
				local myMap = Map.new()

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
				local myMap = Map.new()

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
			jestExpect(Array.sort(map:entries(), function (a, b)
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
end
