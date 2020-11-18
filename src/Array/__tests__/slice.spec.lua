-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck

-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice
return function()
	local slice = require(script.Parent.Parent.slice)

	it("Invalid argument", function()
		expect(function()
			slice(nil, 1)
		end).to.throw()
	end)

	it("Return the whole array", function()
		local animals = {"ant", "bison", "camel", "duck", "elephant"}
		local array_slice = slice(animals)
		expect(array_slice).toEqual({"ant", "bison", "camel", "duck", "elephant"})
	end)

	it("Return from index 3 to end", function()
		local animals = {"ant", "bison", "camel", "duck", "elephant"}
		local array_slice = slice(animals, 3)
		expect(array_slice).toEqual({"camel", "duck", "elephant"})
	end)

	it("Return from index 3 to 5", function()
		local animals = {"ant", "bison", "camel", "duck", "elephant"}
		local array_slice = slice(animals, 3, 5)
		expect(array_slice).toEqual({"camel", "duck"})
	end)

	it("Return from index 2 to index 6 (out of bounds)", function()
		local animals = {"ant", "bison", "camel", "duck", "elephant"}
		local array_slice = slice(animals, 2, 6)
		expect(array_slice).toEqual({"bison", "camel", "duck", "elephant"})
	end)

	describe("Negative indices", function()
		it("Return from index 0 to end", function()
			local animals = {"ant", "bison", "camel", "duck", "elephant"}
			local array_slice = slice(animals, 0)
			expect(array_slice).toEqual({"elephant"})
		end)

		it("Return from index -1 to 0", function()
			local animals = {"ant", "bison", "camel", "duck", "elephant"}
			local array_slice = slice(animals, -1, 0)
			expect(array_slice).toEqual({"duck"})
		end)
	end)

	describe("Return empty array", function()
		it("Start index out of bounds", function()
			local animals = {"ant", "bison", "camel", "duck", "elephant"}
			local array_slice = slice(animals, 10)
			expect(array_slice).toEqual({})
		end)

		it("Start index after end index", function()
			local animals = {"ant", "bison", "camel", "duck", "elephant"}
			local array_slice = slice(animals, 2, 1)
			expect(array_slice).toEqual({})
		end)
	end)
end