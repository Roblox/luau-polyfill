return function()
	local isFinite = require(script.Parent.Parent.isFinite)

	-- test values taken from these examples:
	-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isFinite
	local trueValues = { 0, 2e64 }
	local falseValues = {
		math.huge,
		0/0,
		-math.huge,
		"0",
	}

	for _, value in ipairs(trueValues) do
		it(("returns true for %s"):format(tostring(value)), function()
			expect(isFinite(value)).to.equal(true)
		end)
	end

	for _, value in ipairs(falseValues) do
		it(("returns false for %s"):format(tostring(value)), function()
			expect(isFinite(value)).to.equal(false)
		end)
	end

	it("returns false for nil", function()
		expect(isFinite(nil)).to.equal(false)
	end)
end
