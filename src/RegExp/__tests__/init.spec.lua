return function()
	local RegExp = require(script.Parent.Parent)
	local instanceof = require(script.Parent.Parent.Parent).instanceof

	describe("ignoreCase", function()
		it("has a `ignoreCase` property set to true if the `i` flag is used", function()
			expect(RegExp("foo", "i").ignoreCase).to.equal(true)
		end)

		it("has a `ignoreCase` property set to false by default", function()
			expect(RegExp("foo").ignoreCase).to.equal(false)
		end)
	end)

	describe("multiline", function()
		it("has a `multiline` property set to true if the `m` flag is used", function()
			expect(RegExp("foo", "m").multiline).to.equal(true)
		end)

		it("has a `multiline` property set to false by default", function()
			expect(RegExp("foo").multiline).to.equal(false)
		end)
	end)

	describe("global", function()
		-- deviation: `g` flag not implemented yet
		itSKIP("has a `global` property set to true if the `g` flag is used", function()
			expect(RegExp("foo", "g").global).to.equal(true)
		end)

		-- deviation: `g` flag not implemented yet
		itSKIP("has a `global` property set to false by default", function()
			expect(RegExp("foo").global).to.equal(false)
		end)
	end)

	describe("toString", function()
		it("has a correct tostring output", function()
			expect(tostring(RegExp("pattern"))).to.equal("/pattern/")
		end)

		it("has a correct ordering of flags in tostring output", function()
			expect(tostring(RegExp("regexp\\d", "mi"))).to.equal("/regexp\\d/im")
		end)
	end)

	describe("inheritance", function()
		it("follows our expectations for inheritance", function()
			expect(instanceof(RegExp("test"), RegExp)).to.equal(true)
		end)
	end)

end
