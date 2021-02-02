--!nonstrict
return function()
	local Error = require(script.Parent.Parent)

	it("accepts a message value as an argument", function()
		local err = Error("Some message")

		expect(err.message).to.equal("Some message")
	end)

	it("defaults the `name` field to 'Error'", function()
		local err = Error("")

		expect(err.name).to.equal("Error")
	end)

	it("gets passed through the `error` builtin properly", function()
		local err = Error("Throwing an error")
		local ok, result = pcall(function()
			error(err)
		end)

		expect(ok).to.equal(false)
		expect(result).to.equal(err)
	end)

	it("checks the inheritance of Error", function()
		local MyError = Error:extend("MyError")

		local inst = MyError("my error message")

		expect(inst.message).to.equal("my error message")
		expect(inst.name).to.equal("MyError")

	 	-- inheritance using metatable chain
	 	expect(getmetatable(inst)).to.equal(MyError)
	 	expect(getmetatable(inst).__index).to.equal(Error)
	end)

	it("checks the inheritance of a sub error", function()
		local MyError = Error:extend("MyError")
		local YourError = MyError:extend("YourError")

		local inst = YourError("your error message")

		local inst2 = YourError("your error message 2")

		expect(inst.message).to.equal("your error message")
		expect(inst.name).to.equal("YourError")

		expect(inst2.message).to.equal("your error message 2")
		expect(inst2.name).to.equal("YourError")

		-- inheritance using metatable chain
		expect(getmetatable(inst)).to.equal(YourError)
	 	expect(getmetatable(inst).__index).to.equal(MyError)
	 	expect(getmetatable(getmetatable(inst).__index).__index).to.equal(Error)

	 	expect(getmetatable(inst)).to.equal(getmetatable(inst2))
	 	expect(getmetatable(inst).__index).to.equal(getmetatable(inst2).__index)
	 	expect(getmetatable(getmetatable(inst).__index).__index).to.equal(getmetatable(getmetatable(inst).__index).__index)
	end)

	it("evaluates both toString methods", function()
		local MyError = Error:extend("MyError")

		expect(tostring(MyError)).to.equal("MyError")
		expect(tostring(MyError("my test"))).to.equal("MyError: my test")

		local YourError = Error:extend("YourError")

		expect(tostring(YourError)).to.equal("YourError")
		expect(tostring(YourError("your test"))).to.equal("YourError: your test")
	end)
end