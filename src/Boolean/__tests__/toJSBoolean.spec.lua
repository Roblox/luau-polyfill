return function()
	local toJSBoolean = require(script.Parent.Parent.toJSBoolean)

	-- https://developer.mozilla.org/en-US/docs/Glossary/Falsy
	it("tests javascript falsy values", function()
		expect(toJSBoolean(false)).to.equal(false)
		expect(toJSBoolean(0)).to.equal(false)
		expect(toJSBoolean(-0)).to.equal(false)
		expect(toJSBoolean("")).to.equal(false)
		expect(toJSBoolean(nil)).to.equal(false)
		expect(toJSBoolean(0/0)).to.equal(false)
	end)

	-- https://developer.mozilla.org/en-US/docs/Glossary/Truthy
	it("tests javascript truthy values", function()
		expect(toJSBoolean(true)).to.equal(true)
		expect(toJSBoolean({})).to.equal(true)
		expect(toJSBoolean(42)).to.equal(true)
		expect(toJSBoolean("0")).to.equal(true)
		expect(toJSBoolean("false")).to.equal(true)
		expect(toJSBoolean(DateTime.now())).to.equal(true)
		expect(toJSBoolean(-42)).to.equal(true)
		expect(toJSBoolean(3.14)).to.equal(true)
		expect(toJSBoolean(-3.14)).to.equal(true)
		expect(toJSBoolean(1/0)).to.equal(true)
		expect(toJSBoolean(-1/0)).to.equal(true)
	end)
end
