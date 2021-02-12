return function()
	local Set = require(script.Parent.Parent.Set)

	local AN_ITEM = "bar"
	local ANOTHER_ITEM = "baz"

	describe("constructors", function()
		it("creates an empty array", function()
			local foo = Set.new()
			expect(foo.size).to.equal(0)
		end)

		it("creates a set from an array", function()
			local foo = Set.new({ AN_ITEM, ANOTHER_ITEM })
			expect(foo.size).to.equal(2)
			expect(foo:has(AN_ITEM)).to.equal(true)
			expect(foo:has(ANOTHER_ITEM)).to.equal(true)
		end)

		it("creates a set from a string", function()
			local foo = Set.new("abc")
			expect(foo.size).to.equal(3)
			expect(foo:has("a")).to.equal(true)
			expect(foo:has("b")).to.equal(true)
			expect(foo:has("c")).to.equal(true)
		end)

		it("deduplicates the elements from the iterable", function()
			local foo = Set.new("foo")
			expect(foo.size).to.equal(2)
			expect(foo:has("f")).to.equal(true)
			expect(foo:has("o")).to.equal(true)
		end)

		it("throws when trying to create a set from a non-iterable", function()
			expect(function()
				return Set.new(true)
			end).to.throw("cannot create array from value of type `boolean`")
			expect(function()
				return Set.new(1)
			end).to.throw("cannot create array from value of type `number`")
		end)

		if _G.__DEV__ then
			it("throws when trying to create a set from an object like table", function()
				expect(function()
					return Set.new({ a = true })
				end).to.throw("cannot create array from an object-like table")
			end)
		end
	end)

	describe("add", function()
		it("returns the set object", function()
			local foo = Set.new()
			expect(foo:add(1)).to.equal(foo)
		end)

		it("increments the size if the element is added for the first time", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			expect(foo.size).to.equal(1)
		end)

		it("does not increment the size the second time an element is added", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(AN_ITEM)
			expect(foo.size).to.equal(1)
		end)
	end)

	describe("clear", function()
		it("sets the size to zero", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:clear()
			expect(foo.size).to.equal(0)
		end)

		it("removes the items from the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:clear()
			expect(foo:has(AN_ITEM)).to.equal(false)
		end)
	end)

	describe("delete", function()
		it("removes the items from the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:delete(AN_ITEM)
			expect(foo:has(AN_ITEM)).to.equal(false)
		end)

		it("returns true if the item was in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			expect(foo:delete(AN_ITEM)).to.equal(true)
		end)

		it("returns false if the item was not in the set", function()
			local foo = Set.new()
			expect(foo:delete(AN_ITEM)).to.equal(false)
		end)

		it("decrements the size if the item was in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:delete(AN_ITEM)
			expect(foo.size).to.equal(0)
		end)

		it("does not decrement the size if the item was not in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:delete(ANOTHER_ITEM)
			expect(foo.size).to.equal(1)
		end)
	end)

	describe("has", function()
		it("returns true if the item is in the set", function()
			local foo = Set.new()
			foo:add(AN_ITEM)
			expect(foo:has(AN_ITEM)).to.equal(true)
		end)

		it("returns false if the item is not in the set", function()
			local foo = Set.new()
			expect(foo:has(AN_ITEM)).to.equal(false)
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
			local expect: any = expect
			local foo = Set.new()
			expect(makeArray(foo:ipairs())).toEqual({})
		end)

		it("iterates on the elements by their insertion order", function()
			local expect: any = expect
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(ANOTHER_ITEM)
			expect(makeArray(foo:ipairs())).toEqual({ AN_ITEM, ANOTHER_ITEM })
		end)

		it("does not iterate on removed elements", function()
			local expect: any = expect
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(ANOTHER_ITEM)
			foo:delete(AN_ITEM)
			expect(makeArray(foo:ipairs())).toEqual({ ANOTHER_ITEM })
		end)

		it("iterates on elements if the added back to the set", function()
			local expect: any = expect
			local foo = Set.new()
			foo:add(AN_ITEM)
			foo:add(ANOTHER_ITEM)
			foo:delete(AN_ITEM)
			foo:add(AN_ITEM)
			expect(makeArray(foo:ipairs())).toEqual({ ANOTHER_ITEM, AN_ITEM })
		end)
	end)

	describe("MDN examples", function()
		-- the following tests are adapted from the examples shown on the MDN documentation:
		-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set
		it("works like MDN documentation example", function()
			local mySet = Set.new()

			expect(mySet:add(1)).to.equal(mySet)
			expect(mySet:add(5)).to.equal(mySet)
			expect(mySet:add(5)).to.equal(mySet)
			expect(mySet:add("some text")).to.equal(mySet)

			local o = { a = 1, b = 2 }

			expect(mySet:add(o)).to.equal(mySet)
			-- // o is referencing a different object, so this is okay
			expect(mySet:add({ a = 1, b = 2 })).to.equal(mySet)
			expect(mySet:has(1)).to.equal(true)

			expect(mySet:has(3)).to.equal(false)

			expect(mySet:has(5)).to.equal(true)
			expect(mySet:has(math.sqrt(25))).to.equal(true)
			expect(mySet:has(("Some Text"):lower())).to.equal(true)
			expect(mySet:has(o)).to.equal(true)

			expect(mySet.size).to.equal(5)

			expect(mySet:delete(5)).to.equal(true)
			expect(mySet:has(5)).to.equal(false)
		end)
	end)
end
