-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck

-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is
return function()
	local is = require(script.Parent.Parent.is)
	it("returns true when given ('foo', 'foo')", function()
		expect(is("foo", "foo")).to.equal(true)
	end)

	it("returns false when given ('foo', 'bar')", function()
		expect(is("foo", "bar")).to.equal(false)
	end)

	it("returns false when given ({}, {})", function()
		expect(is({}, {})).to.equal(false)
	end)

	local foo = { a = 1 }
	local bar = { a = 1 }

	it("returns true when given (foo, foo)", function()
		expect(is(foo, foo)).to.equal(true)
	end)

	it("returns false when given (foo, bar)", function()
		expect(is(foo, bar)).to.equal(false)
	end)

	it("returns true when given (nil, nil)", function()
		expect(is(nil, nil)).to.equal(true)
	end)

	it("returns false when given (0, -0)", function()
		expect(is(0, -0)).to.equal(false)
	end)

	it("returns true when given (-0, -0)", function()
		expect(is(-0, -0)).to.equal(true)
	end)

	it("returns true when given (0 / 0, 0 / 0)", function()
		expect(is(0 / 0, 0 / 0)).to.equal(true)
	end)
end