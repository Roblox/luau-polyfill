-- Tests partially based on examples from:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/isArray
return function()
	local isArray = require(script.Parent.Parent.isArray)

	it("returns false for non-tables", function()
		expect(isArray(nil)).to.equal(false)
		expect(isArray(1)).to.equal(false)
		expect(isArray("hello")).to.equal(false)
		expect(isArray(function() end)).to.equal(false)
		expect(isArray(newproxy(false))).to.equal(false)
	end)

	it("returns false for tables with non-number keys", function()
		expect(isArray({ hello = 1 })).to.equal(false)
		expect(isArray({ [function() end] = 1 })).to.equal(false)
		expect(isArray({ [newproxy(false)] = 1 })).to.equal(false)
	end)

	it("returns false for a table with non-integer key", function()
		expect(isArray({ [0.5] = true })).to.equal(false)
	end)

	it("returns false for a table with a key equal to zero", function()
		expect(isArray({ [0] = true })).to.equal(false)
	end)

	it("returns true for an empty table", function()
		expect(isArray({})).to.equal(true)
	end)

	it("returns false for sparse arrays", function()
		expect(isArray({
			[1] = "1",
			[3] = "3",
		})).to.equal(false)
		expect(isArray({
			[2] = "2",
			[3] = "3",
		})).to.equal(false)
	end)

	it("returns false for tables with non-positive-number keys", function()
		expect(isArray({
			[-2] = "-2",
			[2] = "2",
			[3] = "3",
		})).to.equal(false)
	end)

	it("returns true for valid arrays", function()
		expect(isArray({ "a", "b", "c" })).to.equal(true)
		expect(isArray({ 1, 2, 3 })).to.equal(true)
		expect(isArray({ 1, "b", function() end })).to.equal(true)
	end)
end
