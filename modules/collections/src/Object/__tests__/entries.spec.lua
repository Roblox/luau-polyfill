--!nonstrict
-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/entries
return function()
	local Object = script.Parent.Parent
	local Packages = Object.Parent.Parent

	local entries = require(Object.entries)

	local types = require(Packages.ES7Types)
	type Array<T> = types.Array<T>
	type Object = types.Object
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns an empty array for an empty table", function()
		jestExpect(entries({})).toEqual({})
	end)

	it("returns an array of key-value pairs", function()
		local result: Array<Array<any>> = entries({
			foo = "bar",
			baz = 42,
		})
		table.sort(result, function(a, b)
			return a[1] < b[1]
		end)
		-- Luau FIXME: Luau should see result as  Array<Array<string>>, given object is [string]: any, but it sees it as Array<any> despite all the manual annotation
		jestExpect(result).toEqual({
			{ "baz", 42 },
			{ "foo", "bar" },
		})
	end)

	-- deviation: JS has this behavior, which we don't specifically need now.
	-- To not risk making the function significantly slower, this behavior is
	-- not implemented
	itSKIP("returns an array with the stringified indexes given an array", function()
		jestExpect(entries({ true, false, "foo" :: any })).toEqual({
			{ "1", true :: any },
			{ "2", false :: any },
			{ "3", "foo" },
		})
	end)

	it("coerces a string into an object and returns the list of pairs", function()
		jestExpect(entries("bar")).toEqual({
			{ "1", "b" },
			{ "2", "a" },
			{ "3", "r" },
		})
	end)

	it("returns an empty array for non-table and non-string values", function()
		-- re-cast since typechecking would disallow this abuse case
		local entries_: any = entries :: any
		jestExpect(entries_(10)).toEqual({})
		jestExpect(entries_(true)).toEqual({})
		jestExpect(entries_(function() end)).toEqual({})
	end)

	it("throws given a nil value", function()
		jestExpect(function()
			-- re-cast since typechecking would disallow this abuse case
			entries((nil :: any) :: Object)
		end).toThrow("cannot get entries from a nil value")
	end)
end
