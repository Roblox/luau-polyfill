--!nocheck
-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries
return function()
	local Object = script.Parent.Parent
	local entries = require(Object.entries)

	it("returns an empty array for an empty table", function()
		expect(entries({})).toEqual({})
	end)

	it("returns an array of key-value pairs", function()
		local result = entries({
			foo = "bar",
			baz = 42,
		})
		table.sort(result, function(a, b)
			return a[1] < b[1]
		end)
		expect(result).toEqual({
			{"baz", 42},
			{"foo", "bar"},
		})
	end)

	-- deviation: JS has this behavior, which we don't specifically need now.
	-- To not risk making the function significantly slower, this behavior is
	-- not implemented
	itSKIP("returns an array with the stringified indexes given an array", function()
		expect(entries({true, false, "foo"})).toEqual({
			{"1", true},
			{"2", false},
			{"3", "foo"},
		})
	end)

	it("coerces a string into an object and returns the list of pairs", function()
		expect(entries("bar")).toEqual({
			{"1", "b"},
			{"2", "a"},
			{"3", "r"},
		})
	end)

	it("returns an empty array for non-table and non-string values", function()
		expect(entries(10)).toEqual({})
		expect(entries(true)).toEqual({})
		expect(entries(function() end)).toEqual({})
	end)

	it("throws given a nil value", function()
		expect(function()
			entries(nil)
		end).to.throw("cannot get entries from a nil value")
	end)
end
