local __DEV__ = _G.__DEV__

local instanceof = require("../instanceof")

local Collections = require("@pkg/@jsdotlua/collections")
local Set = Collections.Set
local Map = Collections.Map
local LuauPolyfill = require("@pkg/@jsdotlua/luau-polyfill")
local Error = LuauPolyfill.Error
local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local it = JestGlobals.it
local describe = JestGlobals.describe

-- https://roblox.github.io/lua-style-guide/#prototype-based-classes
it("tests the example from the Lua style guide", function()
	local MyClass = {}
	MyClass.__index = MyClass
	function MyClass.new()
		local self = {
			-- Define members of the instance here, even if they're `nil` by default.
			phrase = "bark",
		}

		-- Tell Lua to fall back to looking in MyClass.__index for missing fields.
		setmetatable(self, MyClass)
		return self
	end

	local myClassObj = MyClass.new()

	jestExpect(instanceof(myClassObj, MyClass)).toEqual(true)

	local MyClass2 = {}
	MyClass2.__index = MyClass2

	jestExpect(instanceof(myClassObj, MyClass2)).toEqual(false)
end)

it("tests inheritance from a grandparent class", function()
	local Foo = {}
	Foo.__index = Foo
	function Foo.new()
		local self = {}
		setmetatable(self, Foo)
		return self
	end

	local Foo2 = {}
	Foo2.__index = Foo2
	setmetatable(Foo2, Foo)
	function Foo2.new()
		local self = Foo.new()
		setmetatable(self :: any, Foo2)
		return self
	end

	local foo2Object = Foo2.new()

	jestExpect(instanceof(foo2Object, Foo)).toEqual(true)
end)

it("tests inheritance of a __call metatable class", function()
	--[[
			this test tries to test inheritance of a class similar to how Error
			and RegExp are implemented

			Specifically, these classes follow a pattern where we can do
				myObj = MyClass()
			as opposed to our usual
				myObj = MyClass.new()
		]]

	local Class = {}
	Class.__index = Class
	Class.classField = 10

	function Class.new()
		local self = {}
		setmetatable(self, Class)
		return self
	end

	setmetatable(Class, {
		__call = Class.new,
	})

	local SubClass = {}
	SubClass.__index = SubClass
	function SubClass.new()
		local self = {}
		setmetatable(self, SubClass)
		return self
	end

	setmetatable(SubClass, {
		__call = function(_self)
			return SubClass.new()
		end,
		__index = Class,
	})

	local subClassObj = SubClass()

	-- expect call as a sanity check that we actually inherit classField
	jestExpect((subClassObj :: any).classField).toEqual(10)

	jestExpect(instanceof(subClassObj, SubClass)).toEqual(true)
	jestExpect(instanceof(subClassObj, Class)).toEqual(true)
end)

it("does not consider metatable relationships without __index to be inheritance", function()
	-- This "class" will not work like inheritance.
	-- Without setting the __index metatable field, behavior won't be inherited.
	local PseudoClass = {}
	function PseudoClass.new()
		local self = {}
		setmetatable(self, PseudoClass)
		return self
	end

	local pseudoClassObj = PseudoClass.new()

	jestExpect(instanceof(pseudoClassObj, PseudoClass)).toEqual(false)
end)

it("returns false when checking instanceof primitive argument", function()
	local Class = {}

	function Class.new() end

	jestExpect(instanceof(nil, Class)).toEqual(false)

	jestExpect(instanceof(function() end, Class)).toEqual(false)
end)

it("keeps track of seen metatables to prevent infinite loops", function()
	local breakingTable = {}
	breakingTable.__index = breakingTable
	setmetatable(breakingTable, breakingTable)
	jestExpect(instanceof(breakingTable, {})).toEqual(false)
end)

if __DEV__ then
	it("errors when checking instanceof nil", function()
		jestExpect(function()
			instanceof(setmetatable({}, {}), nil :: any)
		end).toThrow("Received a non-table as the second argument for instanceof")
	end)
end

describe("works on LuauPolyfill types", function()
	it("Set", function()
		local instance = Set.new()
		jestExpect(instanceof(instance, Set)).toEqual(true)
	end)

	it("Map", function()
		local instance = Map.new()
		instance:set("key1", 123)
		instance:set("key2", 456)
		jestExpect(instanceof(instance, Map)).toEqual(true)
	end)

	it("Error", function()
		local instance = Error.new("some message")
		jestExpect(instanceof(instance, Error)).toEqual(true)
	end)
end)
