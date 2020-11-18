-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck

-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/every
return function()
	local every = require(script.Parent.Parent.every)

	it("Invalid argument", function()
		expect(function()
			every(nil, function() end)
		end).to.throw()
		expect(function()
			every({0, 1}, nil)
		end).to.throw()
	end)

	it("Testing size of all array elements", function()
		local isBigEnough = function(element, index, array) 
			return element >= 10
		end
		expect(every(
			{12, 5, 8, 130, 44},
			isBigEnough
		)).to.equal(false)
		expect(every(
			{12, 54, 18, 130, 44},
			isBigEnough
		)).to.equal(true)
	end)

	it("Modifying initial array", function()
		local arr = {1, 2, 3, 4}
		local expected = {1, 1, 2}
		expect(every(
			arr,
			function(elem, index, a)
				a[index + 1] -= 1
				expect(a[index]).to.equal(expected[index])
				return elem < 2
			end
		)).to.equal(false)
		expect(arr).toEqual({1, 1, 2, 3})
	end)

	it("Appending to initial array", function()
		local arr = {1, 2, 3}
		local expected = {1, 2, 3}
		expect(every(
			arr,
			function(elem, index, a)
				table.insert(a, "new")
				expect(a[index]).to.equal(expected[index])
				return elem < 4
			end
		)).to.equal(true)
		expect(arr).toEqual({1, 2, 3, "new", "new", "new"})
	end)

	it("Deleting from inital array", function()
		local arr = {1, 2, 3, 4}
		local expected = {1, 2}
		expect(every(
			arr,
			function(elem, index, a)
				table.remove(a)
				expect(a[index]).to.equal(expected[index])
				return elem < 4
			end
		)).to.equal(true)
		expect(arr).toEqual({1, 2})
	end)
end