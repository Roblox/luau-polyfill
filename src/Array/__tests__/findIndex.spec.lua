--!nonstrict
return function()
	local Array = script.Parent.Parent
	local findIndex = require(Array.findIndex)

	local function returnTrue()
		return true
	end

	local function returnFalse()
		return false
	end

	it("returns -1 if the array is empty", function()
		expect(findIndex({}, returnTrue)).to.equal(-1)
	end)

	it("returns -1 if the predicate is always false", function()
		expect(findIndex({1, 2, 3}, returnFalse)).to.equal(-1)
	end)

	it("returns the first index where the predicate is true", function()
		local result = findIndex({3, 4, 5, 6}, function(element)
			return element % 2 == 0
		end)
		expect(result).to.equal(2)
	end)

	it("passes the element, its index and the array to the predicate", function()
		local arguments = nil
		local array = {"foo"}
		findIndex(array, function(...)
			arguments = {...}
		end)
		expect(#arguments).to.equal(3)
		expect(arguments[1]).to.equal("foo")
		expect(arguments[2]).to.equal(1)
		expect(arguments[3]).to.equal(array)
	end)

	-- the following tests were taken from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex
	it("returns first element greater than 13", function()
		local array1 = {5, 12, 8, 130, 44}

		local function isLargeNumber(element) return element > 13 end

		expect(findIndex(array1, isLargeNumber)).to.equal(4)
	end)

	it("returns first prime element", function()
		local function isPrime(num)
			for i = 2, num - 1 do
				if num % i == 0 then
					return false
				end
			end

			return num > 1
		end

		expect(findIndex({4, 6, 8, 9, 12}, isPrime)).to.equal(-1)
		expect(findIndex({4, 6, 7, 9, 12}, isPrime)).to.equal(3)
	end)

	it("returns first matching string", function()
		local fruits = {"apple", "banana", "cantaloupe", "blueberries", "grapefruit"}

		expect(findIndex(fruits, function(fruit) return fruit == "blueberries" end)).to.equal(4)
	end)
end
