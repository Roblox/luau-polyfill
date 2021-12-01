-- inspired by:
-- https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/__tests__/inspect-test.js
-- https://github.com/edam/inspect.lua/blob/master/spec/inspect_spec.lua
return function()
	local srcWorkspace = script.Parent.Parent.Parent
	local Packages = srcWorkspace.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local Promise = require(Packages.Dev.Promise)
	local inspect = require(srcWorkspace).util.inspect
	local Set = require(srcWorkspace).Set
	type Array<T> = { [number]: T }
	type Object = { [string]: any }

	describe("inspect", function()
		-- it("undefined", function()
		-- 	jestExpect(inspect(nil)).toBe("undefined")
		-- end)

		it("null", function()
			jestExpect(inspect(nil)).toBe("nil")
		end)

		it("boolean", function()
			jestExpect(inspect(true)).toBe("true")
			jestExpect(inspect(false)).toBe("false")
		end)

		it("string", function()
			jestExpect(inspect("")).toBe('""')
			jestExpect(inspect("abc")).toBe('"abc"')
			jestExpect(inspect('"')).toBe('"\\""')
			jestExpect(inspect("\t\n")).toBe('"\\t\\n"')
			jestExpect(inspect("\1")).toBe('"\\u0001"')
			jestExpect(inspect("\\")).toBe('"\\\\"')
			jestExpect(inspect("string with both 'apostrophe' and \"quote\" characters")).toBe(
				'"string with both \'apostrophe\' and \\"quote\\" characters"'
			)
		end)

		it("number", function()
			jestExpect(inspect(0)).toBe("0")
			jestExpect(inspect(3.14)).toBe("3.14")
			jestExpect(inspect(0 / 0)).toBe("NaN")
			jestExpect(inspect(math.huge)).toBe("Infinity")
			jestExpect(inspect(-math.huge)).toBe("-Infinity")
		end)

		it("function", function()
			local unnamedFuncStr = inspect(function()
				error("set us up the b0mb")
			end)

			jestExpect(unnamedFuncStr).toBe("[function]")

			local function namedFunc()
				error(false)
			end

			jestExpect(inspect(namedFunc)).toBe("[function namedFunc]")
		end)

		it("array", function()
			jestExpect(inspect({})).toBe("[]")
			-- deviation: Lua does not handle nil elements
			jestExpect(inspect({ true })).toBe("[true]")
			jestExpect(inspect({ 1, 0 / 0 })).toBe("[1, NaN]")
			jestExpect(inspect({ { "a", "b" }, "c" } :: Array<any>)).toBe('[["a", "b"], "c"]')

			jestExpect(inspect({ { {} } })).toBe("[[[]]]")
			jestExpect(inspect({ { { "a" } } })).toBe("[[[Array]]]")
			jestExpect(inspect({ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 })).toBe("[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]")

			jestExpect(inspect({ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })).toBe(
				"[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ... 1 more item]"
			)

			jestExpect(inspect({ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 })).toBe(
				"[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ... 2 more items]"
			)
		end)

		it("object", function()
			-- ROBLOX deviation: an empty table is considered an empty array
			-- jestExpect(inspect({})).toBe("{}")
			jestExpect(inspect({ a = 1 })).toBe("{ a: 1 }")
			jestExpect(inspect({ a = 1, b = 2 })).toBe("{ a: 1, b: 2 }")
			jestExpect(inspect({ array = { false, 0 } :: Array<any> })).toBe("{ array: [false, 0] }")

			jestExpect(inspect({ a = { b = {} } })).toBe("{ a: { b: [] } }")
			jestExpect(inspect({ a = { b = { c = 1 } } })).toBe("{ a: { b: [Object] } }")

			jestExpect(inspect({ [3.14159] = true :: any, 1, 2 } :: any)).toBe("{ 1, 2, 3.14159: true }")
			jestExpect(inspect({ 1, 2, [-3] = 3 } :: any)).toBe("{ 1, 2, -3: 3 }")

			-- ROBLOX deviation:
			-- local map = Object.create(nil)
			-- map.a = true
			-- map.b = nil
			-- jestExpect(inspect(map)).toBe("{ a: true, b: null }")
		end)

		it("Set", function()
			jestExpect(inspect(Set.new({ 31337, "foo" } :: Array<any>))).toBe('Set (2) [31337, "foo"]')
			jestExpect(inspect(Set.new({ Set.new({ 90210, "baz" } :: Array<any>) }))).toBe(
				'Set (1) [Set (2) [90210, "baz"]]'
			)
			jestExpect(inspect(Set.new({}))).toBe("Set []")
		end)

		it("use toJSON if provided", function()
			local object = {
				toJSON = function()
					return "<json value>"
				end,
			}

			jestExpect(inspect(object)).toBe("<json value>")
		end)

		it("handles toJSON that return `this` should work", function()
			local object = {}
			object.toJSON = function()
				return object
			end

			jestExpect(inspect(object)).toBe("{ toJSON: [function] }")
		end)

		it("handles toJSON returning object values", function()
			local object = {
				toJSON = function()
					return { json = "value" }
				end,
			}

			jestExpect(inspect(object)).toBe('{ json: "value" }')
		end)

		it("handles toJSON function that uses this", function()
			local object = {
				str = "Hello World!",
				toJSON = function(self)
					return self.str
				end,
			}

			jestExpect(inspect(object)).toBe("Hello World!")
		end)

		it("detect circular objects", function()
			local obj = {}

			obj.self = obj
			obj.deepSelf = { self = obj }

			jestExpect(inspect(obj)).toBe("{ deepSelf: { self: [Circular] }, self: [Circular] }")

			local array = {}

			array[1] = array
			array[2] = { array }

			jestExpect(inspect(array)).toBe("[[Circular], [[Circular]]]")

			local mixed = { array = {} }

			mixed.array[1] = mixed

			jestExpect(inspect(mixed)).toBe("{ array: [[Circular]] }")

			local customB
			local customA = {
				toJSON = function()
					return customB
				end,
			}
			customB = {
				toJSON = function()
					return customA
				end,
			}

			jestExpect(inspect(customA)).toBe("[Circular]")
		end)

		-- it("Use class names for the short form of an object", () => {
		-- 	class Foo {
		-- 		foo: string

		-- 		constructor() {
		-- 			this.foo = "bar"
		-- 		}
		-- 	}

		-- 	jestExpect(inspect({{new Foo()}})).toBe("[[[Foo]]]")

		-- 	(Foo.prototype: any)[Symbol.toStringTag] = "Bar"
		-- 	jestExpect(inspect({{new Foo()}})).toBe("[[[Bar]]]")

		-- 	local objectWithoutClassName = new (function () {
		-- 	this.foo = 1
		-- 	})()
		-- 	jestExpect(inspect({{objectWithoutClassName}})).toBe("[[[Object]]]")
		-- end)

		it("uses __tostring when available", function()
			jestExpect(inspect(Promise.new(function() end))).toBe("Promise(Started)")
			local function abc()
				return true
			end
			-- ROBLOX TODO: This will need updating when Promise library shows original named funtions
			jestExpect(inspect(Promise.new(abc))).toBe("Promise(Started)")
		end)
	end)
end
