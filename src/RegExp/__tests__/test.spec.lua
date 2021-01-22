return function()
	local RegExp = require(script.Parent.Parent)

	it("returns true when the regex matches", function()
		local re = RegExp("a")
		expect(re:test("a")).to.equal(true)
	end)

	it("returns false when the regex does not match", function()
		local re = RegExp("a")
		expect(re:test("b")).to.equal(false)
	end)
end
