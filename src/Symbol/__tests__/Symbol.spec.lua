return function()
	--[[
		Tests in this file are from the Symbol code in Roact:
		https://github.com/Roblox/roact/blob/v1.3.1/src/Symbol.spec.lua

		and from interpretation of this spec:
		https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
	]]
	local Symbol = require(script.Parent.Parent)
	local GlobalRegistry = require(script.Parent.Parent.GlobalRegistry)

	describe("New symbols", function()
		it("should give an opaque object", function()
			local symbol = Symbol("foo")

			expect(symbol).to.be.a("userdata")
		end)

		it("should coerce to a default name if none is given", function()
			local symbol = Symbol()

			expect(tostring(symbol)).to.equal("Symbol()")
		end)

		it("should coerce to the given name", function()
			local symbol = Symbol("foo")

			expect(tostring(symbol)).to.equal("Symbol(foo)")
		end)

		it("should be unique when constructed", function()
			local symbolA = Symbol("abc")
			local symbolB = Symbol("abc")

			expect(symbolA).never.to.equal(symbolB)
		end)
	end)

	describe("Global registry", function()
		beforeEach(function()
			GlobalRegistry.__clear()
		end)

		it("should return a symbol for items referenced for the first time", function()
			local fooSymbol = Symbol.for_("foo")
			local barSymbol = Symbol.for_("bar")

			expect(typeof(fooSymbol)).to.equal(typeof(Symbol()))
			expect(tostring(fooSymbol)).to.equal("Symbol(foo)")
			expect(typeof(barSymbol)).to.equal(typeof(Symbol()))
			expect(tostring(barSymbol)).to.equal("Symbol(bar)")
		end)

		it("should return the same symbol object for the same string", function()
			local fooSymbol1 = Symbol.for_("foo")
			local fooSymbol2 = Symbol.for_("foo")

			expect(fooSymbol1).to.equal(fooSymbol2)
		end)
	end)
end
