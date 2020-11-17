return function()
	local keys = require(script.Parent.Parent.keys)

	it("returns an empty array for an empty table", function()
		expect(#keys({})).to.equal(0)
	end)

	it("returns an array with the table keys", function()
		local t = { foo = true, bar = false }
		local result = keys(t)
		expect(#result).to.equal(2)
		table.sort(result)
		expect(result[1]).to.equal('bar')
		expect(result[2]).to.equal('foo')
	end)
end
