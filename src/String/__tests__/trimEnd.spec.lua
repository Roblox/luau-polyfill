return function()
	local trimEnd = require(script.Parent.Parent.trimEnd)

	it("does not remove spaces at beginning", function()
		expect(trimEnd("  abc")).to.equal("  abc")
	end)

	it("removes spaces at end", function()
		expect(trimEnd("abc   ")).to.equal("abc")
	end)

	it("removes spaces at only at end", function()
		expect(trimEnd("  abc   ")).to.equal("  abc")
	end)

	it("does not remove spaces in the middle", function()
		expect(trimEnd("a b c")).to.equal("a b c")
	end)

	it("removes all types of spaces", function()
		expect(trimEnd("abc\r\n\t\f\v")).to.equal("abc")
	end)

	it("returns an empty string if there are only spaces", function()
		expect(trimEnd("    ")).to.equal("")
	end)
end
