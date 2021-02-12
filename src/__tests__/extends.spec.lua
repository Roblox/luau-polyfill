--!nocheck
return function()
	local Workspace = require(script.Parent.Parent)
	local extends = Workspace.extends
	local instanceof = Workspace.instanceof

	local Error = Workspace.Error

	-- https://roblox.github.io/lua-style-guide/#prototype-based-classes
	it("extends the example from the Lua style guide", function()
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

		local MySubClass = extends(MyClass, "MySubClass", function(self, phrase)
			self.phrase = phrase
		end)

		local inst = MySubClass.new("meow")
		expect(inst.phrase).to.equal("meow")
		expect(instanceof(inst), MySubClass)
		expect(instanceof(inst), MyClass)
	end)

	-- More generally, this test checks inheritance for a class with a __call method defined
	it("extending the Error class", function()
		local SubError = extends(Error, "SubError", function(self, message)
			self.message = message
			self.name = "SubError"
		end)

		local inst = SubError("test2")
		expect(inst.message).to.equal("test2")
		expect(inst.name).to.equal("SubError")
		expect(instanceof(inst, SubError))
		expect(instanceof(inst, Error))
	end)

	it("tests multiple extensions of error and their tostring methods", function()
		local SubError = extends(Error, "SubError", function(self)
		end)

		local inst = SubError()
		expect(tostring(SubError)).to.equal("SubError")
		-- since there is no message or name, it defaults to just Error
		expect(tostring(inst)).to.equal("Error")

		local SubSubError = extends(SubError, "SubSubError", function(self, message)
			self.message = message
			self.name = "SubSubError"
		end)

		inst = SubSubError()
		expect(tostring(inst)).to.equal("SubSubError")

		inst = SubSubError("msg")
		expect(tostring(inst)).to.equal("SubSubError: msg")
	end)
end
