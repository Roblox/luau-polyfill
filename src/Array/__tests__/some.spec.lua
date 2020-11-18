-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck

-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/some
return function()
	local some = require(script.Parent.Parent.some)

	it("Invalid argument", function()
		expect(function()
			some(nil, function() end)
		end).to.throw()
		expect(function()
			some({0, 1}, nil)
		end).to.throw()
	end)

	it("Testing value of array elements", function()
		local isBiggerthan10 = function(element, index, array)
			return element > 10
		end
		expect(some({2, 5, 8, 1, 4}, isBiggerthan10)).to.equal(false)
		expect(some({12, 5, 8, 1, 4}, isBiggerthan10)).to.equal(true)
	end)

	it("Checking whether a value exists in an array", function()
		local fruits = {"apple", "banana", "mango", "guava"}
		local checkAvailability = function(arr, val)
			return some(arr, function(arrVal)
				return val == arrVal
			end)
		end
		expect(checkAvailability(fruits, "kela")).to.equal(false)
		expect(checkAvailability(fruits, "banana")).to.equal(true)
	end)

	it("Converting any value to Boolean", function()
		local truthy_values = {true, "true", 1}
		local getBoolean = function(value)
			return some(truthy_values, function(t)
				return t == value
			end)
		end
		expect(getBoolean(false)).to.equal(false)
		expect(getBoolean("false")).to.equal(false)
		expect(getBoolean(1)).to.equal(true)
		expect(getBoolean("true")).to.equal(true)
	end)
end