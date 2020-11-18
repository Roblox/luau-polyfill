return function()
	local Array = script.Parent.Parent
	local find = require(Array.find)

	local function returnTrue()
		return true
	end

	local function returnFalse()
		return false
	end

	it("returns nil if the array is empty", function()
		expect(find({}, returnTrue)).to.equal(nil)
	end)

	it("returns nil if the predicate is always false", function()
		expect(find({1, 2, 3}, returnFalse)).to.equal(nil)
	end)

	it("returns the first element where the predicate is true", function()
		local result = find({3, 4, 5, 6}, function(element)
			return element % 2 == 0
		end)
		expect(result).to.equal(4)
	end)

	it("passes the element, its index and the array to the predicate", function()
		local arguments = nil
		local array = {"foo"}
		find(array, function(...)
			arguments = {...}
		end)
		expect(#arguments).to.equal(3)
		expect(arguments[1]).to.equal("foo")
		expect(arguments[2]).to.equal(1)
		expect(arguments[3]).to.equal(array)
	end)
end
