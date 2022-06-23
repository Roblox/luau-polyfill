-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/from
return function()
	local Array = script.Parent.Parent
	local LuauPolyfill = Array.Parent
	local types = require(LuauPolyfill.types)
	type Array<T> = types.Array<T>
	local from = require(Array.from)
	local Set = require(LuauPolyfill).Set
	local Map = require(LuauPolyfill).Map

	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("creates a array of characters given a string", function()
		jestExpect(from("bar")).toEqual({ "b", "a", "r" })
	end)

	it("creates an array from another array", function()
		jestExpect(from({ "foo", "bar" })).toEqual({ "foo", "bar" })
	end)

	-- not documented on MDN, but consistent across nodejs, Firefox, and Safari
	it("returns an empty array given a number", function()
		-- re-cast since typechecking would disallow this abuse case
		local from_: any = from :: any
		jestExpect(from_(10)).toEqual({})
	end)

	it("returns an empty array given an empty table", function()
		jestExpect(from({})).toEqual({})
	end)

	it("returns an empty array given a map-like table", function()
		jestExpect(from({ foo = "bar" })).toEqual({})
	end)

	it("throws when given nil", function()
		jestExpect(function()
			-- re-cast since typechecking would disallow this abuse case
			local from_: any = from :: any
			from_(nil)
		end).toThrow("cannot create array from a nil value")
	end)

	it("returns an array from a Set", function()
		jestExpect(from(Set.new({ 1, 3 }))).toEqual({ 1, 3 })
	end)

	it("returns an empty array from an empty Set", function()
		jestExpect(from(Set.new())).toEqual({})
	end)

	it("returns an array from a Map", function()
		local map = Map.new()
		map:set("key1", 31337)
		map:set("key2", 90210)
		-- Luau FIXME: Luau doesn't understand multi-typed arrays
		jestExpect(from(map)).toEqual({ { "key1", 31337 :: any }, { "key2", 90210 :: any } })
	end)

	it("returns an empty array from an empty Map", function()
		jestExpect(from(Map.new())).toEqual({})
	end)

	describe("with mapping function", function()
		it("maps each character", function()
			jestExpect(from("bar", function(character: string, index)
				return character .. index
			end)).toEqual({ "b1", "a2", "r3" })
		end)

		it("maps each element of the array", function()
			jestExpect(from({ 10, 20 }, function(element, index)
				-- Luau FIXME: Luau should infer element type as number without annotation
				return element :: number + index
			end)).toEqual({ 11, 22 })
		end)

		it("maps each element of the array with this arg", function()
			local this = { state = 7 }
			jestExpect(from({ 10, 20 }, function(self, element)
				-- Luau FIXME: Luau should infer element type as number without annotation
				return element :: number + self.state
			end, this)).toEqual({ 17, 27 })
		end)

		it("maps each element of the array from a Set", function()
			jestExpect(from(Set.new({ 1, 3 }), function(element, index)
				-- Luau FIXME: Luau should infer element type as number without annotation
				return element :: number + index
			end)).toEqual({ 2, 5 })
		end)

		it("maps each element of the array from a Map", function()
			local map = Map.new()
			map:set(-90210, 90210)
			jestExpect(from(map, function(element: Array<number>, index)
				return element[1] + element[2] + index
			end)).toEqual({ -90210 + 90210 + 1 })
		end)
	end)
end
