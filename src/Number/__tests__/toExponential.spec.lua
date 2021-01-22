--!nocheck

return function()
	local toExponential = require(script.Parent.Parent.toExponential)

	describe("returns nil for invalid input", function()
		it("toExponential(nil)", function()
			expect(toExponential(nil)).to.equal(nil)
		end)

		it("toExponential('abcd')", function()
			expect(toExponential('abcd')).to.equal(nil)
		end)
	end)

	describe("throws for invalid values of fractionDigits", function()
		it("toExponential(77.1234, -1)", function()
			expect(function() toExponential(77.1234, -1) end).to.throw()
		end)

		it("toExponential(77.1234, 101)", function()
			expect(function() toExponential(77.1234, 101) end).to.throw()
		end)

		it("toExponential(77.1234, 'abcd')", function()
			expect(function() toExponential(77.1234, 'abcd') end).to.throw()
		end)
	end)

	it("toExponential(77.1234)", function()
		expect(toExponential(77.1234)).to.equal("7.71234e+1")
	end)

	it("toExponential(77.1234, 0)", function()
		expect(toExponential(77.1234, 0)).to.equal("8e+1")
	end)

	it("toExponential(77.1234, 2)", function()
		expect(toExponential(77.1234, 2)).to.equal("7.71e+1")
	end)

	it("toExponential(77.1234, 4)", function()
		expect(toExponential(77.1234, 4)).to.equal("7.7123e+1")
	end)

	it("toExponential('77.1234')", function()
		expect(toExponential(77.1234)).to.equal("7.71234e+1")
	end)

	it("toExponential(77)", function()
		expect(toExponential(77)).to.equal("7.7e+1")
	end)
end