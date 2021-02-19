--!nonstrict
return function()
	local Error = require(script.Parent.Parent)
	local RegExp = require(script.Parent.Parent.Parent).RegExp
	local extends = require(script.Parent.Parent.Parent).extends
	local instanceof = require(script.Parent.Parent.Parent).instanceof

	local MyError = extends(Error, "MyError", function(self, message)
		self.message = message
		self.name = "MyError"
	end)

	local YourError = extends(MyError, "YourError", function(self, message)
		self.message = message
		self.name = "YourError"
	end)

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

	it("checks that Error is a class according to our inheritance standard", function()
		local err = Error("Test")
		expect(instanceof(err, Error)).to.equal(true)
	end)

	it("checks the inheritance of Error", function()
		local inst = MyError("my error message")

		expect(inst.message).to.equal("my error message")
		expect(inst.name).to.equal("MyError")

		-- inheritance checks
		expect(instanceof(inst, MyError)).to.equal(true)
		expect(instanceof(inst, Error)).to.equal(true)
	end)

	it("checks the inheritance of a sub error", function()
		local inst = YourError("your error message")

		expect(inst.message).to.equal("your error message")
		expect(inst.name).to.equal("YourError")

		-- inheritance checks
		expect(instanceof(inst, YourError))
		expect(instanceof(inst, MyError)).to.equal(true)
		expect(instanceof(inst, Error)).to.equal(true)
	end)

	it("evaluates both toString methods", function()
		expect(tostring(MyError)).to.equal("MyError")
		expect(tostring(MyError("my test"))).to.equal("MyError: my test")

		expect(tostring(YourError)).to.equal("YourError")
		expect(tostring(YourError("your test"))).to.equal("YourError: your test")
	end)

	it("checks Error stack field", function()
		local err = Error("test stack for Error()")
		local err2 = Error.new("test stack for Error.new()")

		local topLineRegExp = RegExp("^.*Error.__tests__\\.Error\\.spec:\\d+")

		expect(topLineRegExp:test(err.stack)).to.equal(true)
		expect(topLineRegExp:test(err2.stack)).to.equal(true)
	end)
end