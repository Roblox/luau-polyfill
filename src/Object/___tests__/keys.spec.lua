--!nocheck
return function()
	local keys = require(script.Parent.Parent.keys)

	it("returns an empty array for an empty table", function()
		expect(#keys({})).to.equal(0)
	end)

	it("returns an array with the table keys", function()
		local t = { foo = true, bar = false }
		local result = keys(t)
		expect(#result).toEqual(2)
		table.sort(result)
		expect(result).toEqual({"bar", "foo"})
	end)

	it("returns an empty array given a number", function()
		expect(keys(1)).toEqual({})
	end)

	it("returns an empty array given boolean", function()
		expect(keys(true)).toEqual({})
		expect(keys(false)).toEqual({})
	end)

	it("throws when given nil", function()
		expect(function()
			keys(nil)
		end).to.throw("cannot extract keys from a nil value")
	end)

	-- deviation: JS has this behavior, which we don't specifically need now.
	-- To not risk making the function significantly slower, this behavior is
	-- not implemented
	itSKIP("returns an array of stringified index given an array", function()
		expect(keys({true, false, true})).toEqual({"1", "2", "3"})
	end)
end
