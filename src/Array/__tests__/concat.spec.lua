-- Some tests are adapted from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/concat
return function()
	local concat = require(script.Parent.Parent.concat)

	it("concatenate arrays with single values", function()
		local expect: any = expect
		expect(concat({ 1 })).toEqual({ 1 })
		expect(concat({ 1 }, { 2 })).toEqual({ 1, 2 })
		expect(concat({ 1 }, { 2 }, { 3 })).toEqual({ 1, 2, 3 })
	end)

	it("concatenate arrays with multiple values", function()
		local expect: any = expect
		expect(concat({ 1 }, { 2, 3 })).toEqual({ 1, 2, 3 })
		expect(concat({ 1, 2 }, { 3 })).toEqual({ 1, 2, 3 })
		expect(concat({ 1, 2 }, { 3, 4 })).toEqual({ 1, 2, 3, 4 })
		expect(concat({ 1, 2 }, { 3, 4 }, { 5, 6 })).toEqual({ 1, 2, 3, 4, 5, 6 })
	end)

	it("concatenate values", function()
		local expect: any = expect
		expect(concat(1)).toEqual({ 1 })
		expect(concat(1, 2)).toEqual({ 1, 2 })
		expect(concat(1, 2, 3)).toEqual({ 1, 2, 3 })
		expect(concat(1, 2, 3, 4)).toEqual({ 1, 2, 3, 4 })
	end)

	it("concatenate values and arrays combination", function()
		local expect: any = expect
		expect(concat(1, { 2 })).toEqual({ 1, 2 })
		expect(concat({ 1 }, 2)).toEqual({ 1, 2 })
		expect(concat({ 1 }, 2, { 3 })).toEqual({ 1, 2, 3 })
		expect(concat({ 1, 2 }, 3, { 4 })).toEqual({ 1, 2, 3, 4 })
	end)

	it("concatenates values to an array", function()
		local expect: any = expect
		local letters = { "a", "b", "c" }
		local alphaNumeric = concat(letters, 1, { 2, 3 })
		expect(alphaNumeric).toEqual({ "a", "b", "c", 1, 2, 3 })
	end)

	it("concatenates nested arrays", function()
		local expect: any = expect
		local num1 = { { 1 } }
		local num2 = { 2, { 3 } }
		local numbers = concat(num1, num2)
		expect(numbers).toEqual({ { 1 }, 2, { 3 } })
	end)

	if _G.__DEV__ then
		it("throws when an object-like table value is passed", function()
			expect(function()
				concat({1, 2}, { a = true })
			end).to.throw("Array.concat(...) only works with array-like tables but it received an object-like table")
		end)
	end
end
