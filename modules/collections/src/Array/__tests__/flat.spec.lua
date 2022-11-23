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
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/flat
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local flat = require(Array.flat)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local arr1 = { 1 :: number | { number }, 2, { 3, 4 } }
	local arr2 = { 1 :: number | { number } | { number | { number } }, 2, { 3 :: number | { number }, 4, { 5, 6 } } }
	local arr3 = { 1 :: any, 2, { 3 :: any, 4, { 5 :: any, 6, { 7 :: any, 8, { 9, 10 } } } } }

	it("should flatten one nested array", function()
		jestExpect(flat(arr1)).toEqual({ 1, 2, 3, 4 })
	end)

	it("should flatten deeply nested array one level deep", function()
		jestExpect(flat(arr2)).toEqual({ 1 :: number | { number }, 2, 3, 4, { 5, 6 } })
	end)

	it("should flatten deeply nested array only two levels deep", function()
		jestExpect(flat(arr2, 2)).toEqual({ 1, 2, 3, 4, 5, 6 })
	end)

	it("should flatten deeply nested array only all the way down", function()
		jestExpect(flat(arr3, math.huge)).toEqual({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
	end)
end
