--!nocheck
return function()
	local Object = script.Parent.Parent
	local values = require(Object.values)

	it("returns the values of a table", function()
		local result = values({
			foo = "bar",
			baz = "zoo",
		})
		table.sort(result)
		expect(result).toEqual({"bar", "zoo"})
	end)

	it("returns the values of an array-like table", function()
		local result = values({"bar", "foo"})
		table.sort(result)
		expect(result).toEqual({"bar", "foo"})
	end)

	it("returns an array of character given a string", function()
		expect(values("bar")).toEqual({"b", "a", "r"})
	end)

	it("throws given nil", function()
		expect(function()
			values(nil)
		end).to.throw("cannot extract values from a nil value")
	end)
end
