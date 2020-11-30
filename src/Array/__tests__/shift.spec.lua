--!nocheck
-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/shift
return function()
	local Array = script.Parent.Parent
	local shift = require(Array.shift)

	it("shifts three element array", function()
		local array1 = {1, 2, 3}

		local firstElement = shift(array1)
		expect(array1).toEqual({2, 3})
		expect(firstElement).to.equal(1)
	end)

	it("removes an element from an array", function()
		local myFish = {"angel", "clown", "mandarin", "surgeon"}

		local shifted = shift(myFish)
		expect(myFish).toEqual({"clown", "mandarin", "surgeon"})
		expect(shifted).to.equal("angel")
	end)

	it("shifts in a loop", function()
		local names = {"Andrew", "Edward", "Paul", "Chris", "John"}
		local nameString = ""
		local name = shift(names)

		while name do
			nameString = nameString .. " " .. name
			name = shift(names) 
		end

		expect(nameString).to.equal(" Andrew Edward Paul Chris John")
	end)

	it("shifts empty array", function()
		local empty = {}
		local none = shift(empty)

		expect(empty).toEqual({})
		expect(none).to.equal(nil)
	end)

	if _G.__DEV__ then
		it("throws error on non-array", function()
			local nonarr = "abc"
			expect(function() shift(nonarr) end).to.throw("Array.shift called on non-array string")
		end)
	end
end