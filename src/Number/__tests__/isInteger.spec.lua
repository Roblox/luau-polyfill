return function()
	local isInteger = require(script.Parent.Parent.isInteger)

	it("returns true when given 0", function()
		expect(isInteger(0)).to.equal(true)
	end)

	it("returns true when given 1", function()
		expect(isInteger(1)).to.equal(true)
	end)

	it("returns true when given -100000", function()
		expect(isInteger(-100000)).to.equal(true)
	end)

	it("returns true when given 99999999999999999999999", function()
		expect(isInteger(99999999999999999999999)).to.equal(true)
	end)

	it("returns true when given 5.0", function()
		expect(isInteger(5.0)).to.equal(true)
	end)

	it("returns false when given 0.1", function()
		expect(isInteger(0.1)).to.equal(false)
	end)

	it("returns false when given math.pi", function()
		expect(isInteger(math.pi)).to.equal(false)
	end)

	it("returns false when given nan", function()
		expect(isInteger(0 / 0)).to.equal(false)
	end)

	it("returns false when given inf", function()
		expect(isInteger(1 / 0)).to.equal(false)
	end)

	it("returns false when given '10'", function()
		expect(isInteger("10")).to.equal(false)
	end)
end
