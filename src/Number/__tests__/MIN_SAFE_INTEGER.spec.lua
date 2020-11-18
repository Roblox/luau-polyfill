return function()
	local Number = script.Parent.Parent
	local MIN_SAFE_INTEGER = require(Number.MIN_SAFE_INTEGER)

	it("is not equal to the next smaller integer", function()
		expect(MIN_SAFE_INTEGER).never.to.equal(MIN_SAFE_INTEGER - 1)
	end)

	it("is the smallest integer possible", function()
		local unsafeInteger = MIN_SAFE_INTEGER - 1
		expect(unsafeInteger).to.equal(unsafeInteger - 1)
	end)
end
