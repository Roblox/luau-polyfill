-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck

-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map
return function()
	local map = require(script.Parent.Parent.map)

	it("Invalid argument", function()
		expect(function()
			map(nil, function() end)
		end).to.throw()
		expect(function()
			map({0, 1}, nil)
		end).to.throw()
	end)

	it("Mapping an array of numbers to an array of square roots", function()
		local numbers = {1, 4, 9}
		local roots = map(numbers, function(num)
			return math.sqrt(num)
		end)
		expect(numbers).toEqual({1, 4, 9})
		expect(roots).toEqual({1, 2, 3})
	end)

	it("Using map to reformat objects in an array", function()
		local kvArray = {
			{key = 1, value = 10},
			{key = 2, value = 20},
			{key = 3, value = 30}
		}
		local reformattedArray = map(kvArray, function(obj)
			local rObj = {}
			rObj[obj.key] = obj.value
			return rObj
		end)
		-- // reformattedArray is now [{1: 10}, {2: 20}, {3: 30}]
		expect(reformattedArray).toEqual({
			{[1] = 10},
			{[2] = 20},
			{[3] = 30},
		})
	end)

	it("Mapping an array of numbers using a function containing an argument", function()
		local numbers = {1, 4, 9}
		local doubles = map(numbers, function(num)
			return num * 2
		end)
		expect(doubles).toEqual({2, 8, 18})
	end)
end