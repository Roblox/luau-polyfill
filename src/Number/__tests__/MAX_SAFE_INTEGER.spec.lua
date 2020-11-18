return function()
	local Number = script.Parent.Parent
	local MAX_SAFE_INTEGER = require(Number.MAX_SAFE_INTEGER)

	it("is not equal to the next bigger integer", function()
		expect(MAX_SAFE_INTEGER).never.to.equal(MAX_SAFE_INTEGER + 1)
	end)

	it("is the biggest integer possible", function()
		local unsafeInteger = MAX_SAFE_INTEGER + 1
		expect(unsafeInteger).to.equal(unsafeInteger + 1)
	end)
end
