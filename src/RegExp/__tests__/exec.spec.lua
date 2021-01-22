return function()
	local RegExp = require(script.Parent.Parent)

	-- deviation: since we can't have `nil` values in list-like
	-- tables, we have to return the total number of matches, so
	-- that we can know when to stop iteration
	it("returns the number of matches", function()
		local re = RegExp("abc")
		local result = re:exec("abc")
		expect(result.n).to.equal(1)
	end)

	it("returns the matches starting from index 1", function()
		local re = RegExp("abc")
		local result = re:exec("abc")
		expect(result[1]).to.equal("abc")
	end)

	it("returns the starting position of the match", function()
		local re = RegExp("abc")
		local result = re:exec("aabc")
		expect(result.index).to.equal(2)
	end)
end
