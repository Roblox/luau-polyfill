--!nocheck
return function()
	local instanceof = require(script.Parent.Parent).instanceof

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

		expect(instanceof(myClassObj, MyClass)).to.equal(true)

		local MyClass2 = {}
		MyClass2.__index = MyClass2

		expect(instanceof(myClassObj, MyClass2)).to.equal(false)
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
			setmetatable(self, Foo2)
			return self
		end

		local foo2Object = Foo2.new()

		expect(instanceof(foo2Object, Foo)).to.equal(true)
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
			__call = Class.new
		})


		local SubClass = {}
		SubClass.__index = SubClass
		function SubClass.new()
			local self = {}
			setmetatable(self, SubClass)
			return self
		end

		setmetatable(SubClass, {
			__call = SubClass.new,
			__index = Class
		})

		local subClassObj = SubClass()

		-- expect call as a sanity check that we actually inherit classField
		expect(subClassObj.classField).to.equal(10)

		expect(instanceof(subClassObj, SubClass)).to.equal(true)
		expect(instanceof(subClassObj, Class)).to.equal(true)
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

		expect(instanceof(pseudoClassObj, PseudoClass)).to.equal(false)
	end)

	it("returns false when checking instanceof primitive argument", function()
		local Class = {}

		function Class.new()
		end

		expect(instanceof(nil, Class)).to.equal(false)

		expect(instanceof(function() end, Class)).to.equal(false)
	end)
end
