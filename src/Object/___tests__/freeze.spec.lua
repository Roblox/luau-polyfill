--!nocheck
return function()
	local freeze = require(script.Parent.Parent.freeze)

	it("should return the same table", function()
		local unfrozen = {
			a = 1,
		}
		local frozen = freeze(unfrozen)

		expect(frozen).to.equal(unfrozen)
	end)

	it("should allow access to any keys that were defined when it was frozen", function()
		local t = freeze({
			a = 1,
		})

		expect(t.a).to.equal(1)
	end)

	itFIXME("should prohibit assignment to existing values", function()
		local t = freeze({
			a = 1,
		})
	
		expect(function()
			t.a = 2
		end).to.throw()
	end)

	it("should preserve iteration functionality", function()
		local t = freeze({
			a = 1,
			b = 2,
		})

		local tPairsCopy = {}
		for k, v in pairs(t) do
			tPairsCopy[k] = v
		end

		expect(tPairsCopy).toEqual(t)

		local a = freeze({ "hello", "world" })

		local aIpairsCopy = {}
		for i, v in ipairs(a) do
			aIpairsCopy[i] = v
		end

		expect(aIpairsCopy).toEqual(a)
	end)

	it("should error when setting a nonexistent key", function()
		local t = freeze({
			a = 1,
			b = 2,
		})

		expect(function()
			t.c = 3
		end).to.throw()
	end)
end