--!nocheck
-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/from
return function()
	local Array = script.Parent.Parent
	local from = require(Array.from)

	it("creates a array of characters given a string", function()
		expect(from("bar")).toEqual({"b", "a", "r"})
	end)

	it("creates an array from another array", function()
		expect(from({"foo", "bar"})).toEqual({"foo", "bar"})
	end)

	it("returns an empty array given a number", function()
		expect(from(10)).toEqual({})
	end)

	it("returns an empty array given an empty table", function()
		expect(from({})).toEqual({})
	end)

	it("returns an empty array given a map-like table", function()
		expect(from({foo = "bar"})).toEqual({})
	end)

	it("throws when given nil", function()
		expect(function()
			from(nil)
		end).to.throw("cannot create array from a nil value")
	end)

	describe("with mapping function", function()
		it("maps each character", function()
			expect(
				from("bar", function(character, index)
					return character .. index
				end)
			).toEqual({"b1", "a2", "r3"})
		end)

		it("maps each element of the array", function()
			expect(
				from({10, 20}, function(element, index)
					return element + index
				end)
			).toEqual({11, 22})
		end)
	end)
end
