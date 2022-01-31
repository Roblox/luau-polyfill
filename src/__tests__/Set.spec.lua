--!strict
return function()
	local LuauPolyfill = script.Parent.Parent
	local Set = require(LuauPolyfill.Set)
	type Set<T> = Set.Set<T>
	local Object = require(LuauPolyfill.Object)
	type Object = Object.Object

	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	local AN_ITEM = "bar"
	local ANOTHER_ITEM = "baz"

	describe("constructors", function()
		it("creates an empty array", function()
			local foo = Set.new()
			jestExpect(foo.size).toEqual(0)
		end)

		it("creates a set from an array", function()
			local foo = Set.new({ AN_ITEM, ANOTHER_ITEM })
			jestExpect(foo.size).toEqual(2)
			jestExpect(foo:has(AN_ITEM)).toEqual(true)
			jestExpect(foo:has(ANOTHER_ITEM)).toEqual(true)
		end)

		it("creates a set from an Set", function()
			local foo = Set.new(Set.new({ AN_ITEM, ANOTHER_ITEM }))
			jestExpect(foo.size).toEqual(2)
			jestExpect(foo:has(AN_ITEM)).toEqual(true)
			jestExpect(foo:has(ANOTHER_ITEM)).toEqual(true)
		end)

		it("creates a set from a string", function()
			local foo = Set.new("abc")
			jestExpect(foo.size).toEqual(3)
			jestExpect(foo:has("a")).toEqual(true)
			jestExpect(foo:has("b")).toEqual(true)
			jestExpect(foo:has("c")).toEqual(true)
		end)

		it("deduplicates the elements from the iterable", function()
			local foo = Set.new("foo")
			jestExpect(foo.size).toEqual(2)
			jestExpect(foo:has("f")).toEqual(true)
			jestExpect(foo:has("o")).toEqual(true)
		end)

		it("throws when trying to create a set from a non-iterable", function()
			jestExpect(function()
				return Set.new(true :: any)
			end).toThrow("cannot create array from value of type `boolean`")
			jestExpect(function()
				return Set.new(1 :: any)
			end).toThrow("cannot create array from value of type `number`")
		end)

		if _G.__DEV__ then
			it("throws when trying to create a set from an object like table", function()
				jestExpect(function()
					return Set.new({ a = true })
				end).toThrow("cannot create array from an object-like table")
			end)
		end
	end)

	describe("add", function()
		it("returns the set object", function()
			local foo = Set.new()
			jestExpect(foo:add(1)).toEqual(foo)
		end)

		it("increments the size if the element is added for the first time", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			jestExpect(foo.size).toEqual(1)
		end)

		it("does not increment the size the second time an element is added", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(AN_ITEM)
			jestExpect(foo.size).toEqual(1)
		end)
	end)

	describe("clear", function()
		it("sets the size to zero", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:clear()
			jestExpect(foo.size).toEqual(0)
		end)

		it("removes the items from the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:clear()
			jestExpect(foo:has(AN_ITEM)).toEqual(false)
		end)
	end)

	describe("delete", function()
		it("removes the items from the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:delete(AN_ITEM)
			jestExpect(foo:has(AN_ITEM)).toEqual(false)
		end)

		it("returns true if the item was in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			jestExpect(foo:delete(AN_ITEM)).toEqual(true)
		end)

		it("returns false if the item was not in the set", function()
			local foo = Set.new()
			jestExpect(foo:delete(AN_ITEM)).toEqual(false)
		end)

		it("decrements the size if the item was in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:delete(AN_ITEM)
			jestExpect(foo.size).toEqual(0)
		end)

		it("does not decrement the size if the item was not in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:delete(ANOTHER_ITEM)
			jestExpect(foo.size).toEqual(1)
		end)
	end)

	describe("forEach", function()
		it("forEach a Set of non-mixed keys and values", function()
			local mySet = Set.new({ 1, -1 })
			local mock = jest.fn()
			mySet:add(1)
			mySet:add(-1)
			mySet:add(31337)
			-- note: Luau knows `+` is safe here because it infers value type from Set ctor above
			mySet:forEach(function(value)
				mock(0 + value)
			end)
			jestExpect(mock).toHaveBeenCalledWith(1)
			jestExpect(mock).toHaveBeenCalledWith(-1)
			jestExpect(mock).toHaveBeenCalledWith(31337)
		end)

		it("forEach with 'this' argument", function()
			local mySet = Set.new({ 1, -1 })
			local mock = jest.fn()
			local obj = {
				message = "h0wdy",
			}

			mySet:forEach(function(self, value)
				mock(value, self.message)
			end, obj)
			jestExpect(mock).toHaveBeenCalledWith(1, "h0wdy")
			jestExpect(mock).toHaveBeenCalledWith(-1, "h0wdy")
		end)

		it("forEach a map of mixed keys and values", function()
			local mySet: Set<boolean | number> = Set.new()
			local mock = jest.fn()
			mySet:add(1)
			mySet:add(false)
			mySet:forEach(function(value)
				-- Luau FIXME: based on explicit Set<> above, Luau should know value is boolean | number
				mock(value)
			end)
			jestExpect(mock).toHaveBeenCalledWith(1)
			jestExpect(mock).toHaveBeenCalledWith(false)
		end)

		it("forEach a map after a deletion", function()
			local mySet = Set.new({ { 1 } })
			local mock = jest.fn()
			local two = { 2 }
			mySet:add(two)
			mySet:add({ 3 })
			mySet:delete(two)
			mySet:forEach(function(value, key)
				-- note: Luau knows key is Array<number> due to inference from ctor above
				mock(0 + value[1])
			end)
			jestExpect(mock).toHaveBeenCalledWith(1)
			jestExpect(mock).never.toHaveBeenCalledWith(2)
			jestExpect(mock).toHaveBeenCalledWith(3)
		end)

		it("remove set item during forEach", function()
			local mySet = Set.new({ { 1 } })
			local mock = jest.fn()
			local two = { 2 }
			mySet:add(two)
			mySet:add({ 3 })
			mySet:forEach(function(value, key)
				mySet:delete(two)
				-- note: Luau knows key is Array<number> due to inference from ctor above
				mock(0 + value[1])
			end)
			jestExpect(mock).toHaveBeenCalledWith(1)
			jestExpect(mock).never.toHaveBeenCalledWith(2)
			jestExpect(mock).never.toHaveBeenCalledWith(nil)
			jestExpect(mock).toHaveBeenCalledWith(3)
		end)

		it("add set item during forEach", function()
			local mySet = Set.new({ { 1 } })
			local mock = jest.fn()
			local two = { 2 }
			mySet:add(two)
			mySet:forEach(function(value, key)
				mySet:add({ 3 })
				-- note: Luau knows key is Array<number> due to inference from ctor above
				mock(0 + value[1])
			end)
			jestExpect(mock).toHaveBeenCalledWith(1)
			jestExpect(mock).toHaveBeenCalledWith(2)
			jestExpect(mock).never.toHaveBeenCalledWith(3)
			jestExpect(mock).never.toHaveBeenCalledWith(nil)
		end)

		it("nested forEach", function()
			local mock = jest.fn()
			local kvArray = {
				{ key = 1, value = 10 },
				{ key = 2, value = 20 },
				{ key = 3, value = 30 },
			}
			local mySet = Set.new({
				Set.new(kvArray),
				Set.new(),
			})
			mySet:forEach(function(value)
				value:forEach(function(value)
					mock(value)
				end)
			end)
			jestExpect(mock).toHaveBeenCalledWith({ value = 10, key = 1 })
			jestExpect(mock).toHaveBeenCalledWith({ value = 20, key = 2 })
			jestExpect(mock).toHaveBeenCalledWith({ value = 30, key = 3 })
		end)
	end)

	describe("has", function()
		it("returns true if the item is in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			jestExpect(foo:has(AN_ITEM)).toEqual(true)
		end)

		it("returns false if the item is not in the set", function()
			local foo = Set.new()
			jestExpect(foo:has(AN_ITEM)).toEqual(false)
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
			local foo = Set.new()
			jestExpect(makeArray(foo:ipairs())).toEqual({})
			for _, __ in foo:ipairs() do
				error("should never be called")
			end
		end)

		it("iterates on the elements by their insertion order", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(ANOTHER_ITEM)
			jestExpect(makeArray(foo:ipairs())).toEqual({ AN_ITEM, ANOTHER_ITEM })
		end)

		it("does not iterate on removed elements", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(ANOTHER_ITEM)
			foo:delete(AN_ITEM)
			jestExpect(makeArray(foo:ipairs())).toEqual({ ANOTHER_ITEM })
		end)

		it("iterates on elements if the added back to the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(ANOTHER_ITEM)
			foo:delete(AN_ITEM)
			foo:add(AN_ITEM)
			jestExpect(makeArray(foo:ipairs())).toEqual({ ANOTHER_ITEM, AN_ITEM })
		end)
	end)

	describe("MDN examples", function()
		-- the following tests are adapted from the examples shown on the MDN documentation:
		-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
		it("works like MDN documentation example", function()
			-- note: if you have a mixed-type Set, you'll need to declare the type explicitly
			local mySet: Set<number | string | Object> = Set.new()

			jestExpect(mySet:add(1)).toEqual(mySet)
			jestExpect(mySet:add(5)).toEqual(mySet)
			jestExpect(mySet:add(5)).toEqual(mySet)
			jestExpect(mySet:add("some text")).toEqual(mySet)

			local o = { a = 1, b = 2 }

			jestExpect(mySet:add(o)).toEqual(mySet)
			-- // o is referencing a different object, so this is okay
			jestExpect(mySet:add({ a = 1, b = 2 })).toEqual(mySet)
			jestExpect(mySet:has(1)).toEqual(true)

			jestExpect(mySet:has(3)).toEqual(false)

			jestExpect(mySet:has(5)).toEqual(true)
			jestExpect(mySet:has(math.sqrt(25))).toEqual(true)
			jestExpect(mySet:has(("Some Text"):lower())).toEqual(true)
			jestExpect(mySet:has(o)).toEqual(true)

			jestExpect(mySet.size).toEqual(5)

			jestExpect(mySet:delete(5)).toEqual(true)
			jestExpect(mySet:has(5)).toEqual(false)
		end)
	end)
end
