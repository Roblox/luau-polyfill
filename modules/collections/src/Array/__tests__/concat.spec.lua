--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
-- Some tests are adapted from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/concat
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local concat = require(Array.concat)
	local types = require(Packages.ES7Types)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	type Array<T> = types.Array<T>

	it("concatenate arrays with single values", function()
		jestExpect(concat({ 1 })).toEqual({ 1 })
		jestExpect(concat({ 1 }, { 2 })).toEqual({ 1, 2 })
		jestExpect(concat({ 1 }, { 2 }, { 3 })).toEqual({ 1, 2, 3 })
	end)

	it("concatenate arrays with multiple values", function()
		jestExpect(concat({ 1 }, { 2, 3 })).toEqual({ 1, 2, 3 })
		jestExpect(concat({ 1, 2 }, { 3 })).toEqual({ 1, 2, 3 })
		jestExpect(concat({ 1, 2 }, { 3, 4 })).toEqual({ 1, 2, 3, 4 })
		jestExpect(concat({ 1, 2 }, { 3, 4 }, { 5, 6 })).toEqual({
			1,
			2,
			3,
			4,
			5,
			6,
		})
	end)

	it("concatenate values", function()
		jestExpect(concat({}, 1)).toEqual({ 1 })
		jestExpect(concat({}, 1, 2)).toEqual({ 1, 2 })
		-- jestExpect(concat({}, "alice", 2)).toEqual({ 1, 2 }) -- correctly results in a type error
		-- jestExpect(concat({"alice"}, 1, 2)).toEqual({ 1, 2 }) -- Luau FIXME: false negative, CLI-49876
		jestExpect(concat({}, 1, 2, 3)).toEqual({ 1, 2, 3 })
		jestExpect(concat({}, 1, 2, 3, 4)).toEqual({ 1, 2, 3, 4 })
	end)

	it("concatenate values and arrays combination", function()
		jestExpect(concat({}, 1, { 2 })).toEqual({ 1, 2 })
		jestExpect(concat({ 1 }, 2)).toEqual({ 1, 2 })
		jestExpect(concat({ 1 }, 2, { 3 })).toEqual({ 1, 2, 3 })
		jestExpect(concat({ 1, 2 }, 3, { 4 })).toEqual({ 1, 2, 3, 4 })
	end)

	it("concatenates values to an array", function()
		local letters: Array<any> = { "a", "b", "c" }
		local alphaNumeric = concat(letters, 1, { 2, 3 })
		jestExpect(alphaNumeric).toEqual({ "a", "b", "c", 1, 2, 3 } :: Array<any>)
	end)

	it("concatenates values to new array when first argument isn't an array", function()
		local alphaNumeric = concat(1, { 2, 3 })
		jestExpect(alphaNumeric).toEqual({ 1, 2, 3 })
	end)

	it("concatenates nested arrays", function()
		local num1 = { { 1 } }
		local num2: Array<any> = { 2, { 3 } }
		local numbers = concat(num1, num2)
		jestExpect(numbers).toEqual({ { 1 }, 2, { 3 } } :: Array<any>)
	end)

	if _G.__DEV__ then
		it("throws when an object-like table value is passed", function()
			jestExpect(function()
				concat({ 1, 2 }, { a = true })
			end).toThrow("Array.concat(...) only works with array-like tables but it received an object-like table")
		end)
	end
end
