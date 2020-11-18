return function()
	local Number = require(script.Parent)

	it("has MAX_SAFE_INTEGER constant", function()
		expect(Number.MAX_SAFE_INTEGER).to.be.a("number")
	end)

	it("has MIN_SAFE_INTEGER constant", function()
		expect(Number.MIN_SAFE_INTEGER).to.be.a("number")
	end)
end
