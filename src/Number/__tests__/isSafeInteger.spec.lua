return function()
	local isSafeInteger = require(script.Parent.Parent.isSafeInteger)

	it("returns true when given 3", function()
		expect(isSafeInteger(3)).to.equal(true)
	end)

	it("returns true when given math.pow(2, 53) - 1", function()
		expect(isSafeInteger(math.pow(2, 53) - 1)).to.equal(true)
	end)

	it("returns true when given 3.0", function()
		expect(isSafeInteger(3.0)).to.equal(true)
	end)

	it("returns false when given math.pow(2, 53)", function()
		expect(isSafeInteger(math.pow(2, 53))).to.equal(false)
	end)

	it("returns false when given nan", function()
		expect(isSafeInteger(0 / 0)).to.equal(false)
	end)

	it("returns false when given inf", function()
		expect(isSafeInteger(1 / 0)).to.equal(false)
	end)

	it("returns false when given '3'", function()
		expect(isSafeInteger("3")).to.equal(false)
	end)

	it("returns false when given 3.1", function()
		expect(isSafeInteger(3.1)).to.equal(false)
	end)
end
