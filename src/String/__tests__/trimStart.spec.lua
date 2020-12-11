return function()
	local trimStart = require(script.Parent.Parent.trimStart)

	it("removes spaces at beginning", function()
		expect(trimStart("  abc")).to.equal("abc")
	end)

	it("does not remove spaces at end", function()
		expect(trimStart("abc   ")).to.equal("abc   ")
	end)

	it("removes spaces at only at beginning", function()
		expect(trimStart("  abc   ")).to.equal("abc   ")
	end)

	it("does not remove spaces in the middle", function()
		expect(trimStart("a b c")).to.equal("a b c")
	end)

	it("removes all types of spaces", function()
		expect(trimStart("\r\n\t\f\vabc")).to.equal("abc")
	end)

	it("returns an empty string if there are only spaces", function()
		expect(trimStart("    ")).to.equal("")
	end)
end
