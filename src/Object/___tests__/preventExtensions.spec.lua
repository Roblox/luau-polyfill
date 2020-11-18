--!nocheck
return function()
	local preventExtensions = require(script.Parent.Parent.preventExtensions)

	it("should return the same table", function()
		local base = {
			a = 1,
		}
		local modified = preventExtensions(base)

		expect(modified).to.equal(base)
	end)

	it("should allow access to any keys that were defined before it's called", function()
		local t = preventExtensions({
			a = 1,
		})

		expect(t.a).to.equal(1)
	end)

	it("should allow mutation of existing values", function()
		local t = preventExtensions({
			a = 1,
		})

		t.a = 2
		expect(t.a).to.equal(2)
	end)

	it("should preserve iteration functionality", function()
		local t = preventExtensions({
			a = 1,
			b = 2,
		})

		local tPairsCopy = {}
		for k, v in pairs(t) do
			tPairsCopy[k] = v
		end

		expect(tPairsCopy).toEqual(t)

		local a = preventExtensions({ "hello", "world" })

		local aIpairsCopy = {}
		for i, v in ipairs(a) do
			aIpairsCopy[i] = v
		end

		expect(aIpairsCopy).toEqual(a)
	end)

	it("should error when setting a nonexistent key", function()
		local t = preventExtensions({
			a = 1,
			b = 2,
		})

		expect(function()
			t.c = 3
		end).to.throw()
	end)
end