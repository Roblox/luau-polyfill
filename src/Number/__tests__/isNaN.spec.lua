return function()
	local isNaN = require(script.Parent.Parent.isNaN)

	it("returns true when given 0/0", function()
		expect(isNaN(0/0)).to.equal(true)
	end)

	it("returns false when given \"nan\"", function()
		expect(isNaN("nan")).to.equal(false)
	end)

	it("returns false when given nil", function()
		expect(isNaN(nil)).to.equal(false)
	end)

	it("returns false when given {}", function()
		expect(isNaN({})).to.equal(false)
	end)

	it("returns false when given \"blabla\"", function()
		expect(isNaN("blabla")).to.equal(false)
	end)

	it("returns false when given true", function()
		expect(isNaN(true)).to.equal(false)
	end)

	it("returns false when given 37", function()
		expect(isNaN(37)).to.equal(false)
	end)

	it("returns false when given an empty string", function()
		expect(isNaN("")).to.equal(false)
	end)
end