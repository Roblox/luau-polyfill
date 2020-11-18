-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck

-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce
return function()
	local reduce = require(script.Parent.Parent.reduce)
	it("Invalid argument", function()
		expect(function()
			reduce(nil, function() end)
		end).to.throw()
		expect(function()
			reduce({0, 1}, nil)
		end).to.throw()
	end)

	it("Sum all the values of an array", function()
		expect(
			reduce(
				{1, 2, 3, 4},
				function(accumulator, currentValue)
					return accumulator + currentValue
				end
			)
		).to.equal(10)
	end)

	it("Sum of values in an object array", function()
		expect(
			reduce(
				{ { x = 1 }, { x = 2 }, { x = 3 } },
				function(accumulator, currentValue)
					return accumulator + currentValue.x
				end,
				0
			)
		).to.equal(6)
	end)

	it("Counting instances of values in an object", function()
		local names = {"Alice", "Bob", "Tiff", "Bruce", "Alice"}
		local reduced = reduce(
			names,
			function(allNames, name)
				if allNames[name] ~= nil then
					allNames[name] = allNames[name] + 1
				else
					allNames[name] = 1
				end
				return allNames
			end,
			{}
		)
		expect(reduced).toEqual({
			Alice = 2,
			Bob = 1,
			Tiff = 1,
			Bruce = 1,
		})
	end)

	it("Grouping objects by a property", function()
		local people = {
			{ name = "Alice", age = 21 },
			{ name = "Max", age = 20 },
			{ name = "Jane", age = 20 }
		}
		local reduced = reduce(
			people,
			function(acc, obj)
				local key = obj["age"]
				if acc[key] == nil then
					acc[key] = {}
				end
				table.insert(acc[key], obj)
				return acc
			end,
			{}
		)
		expect(reduced).toEqual({
			[20] = {
				{ name = "Max", age = 20 },
				{ name = "Jane", age = 20 },
			},
			[21] = {
				{ name = "Alice", age = 21 },
			}
		})
	end)
end