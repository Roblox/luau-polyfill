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
-- tests based on the examples provided on MDN web docs:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/shift
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local shift = require(Array.shift)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("shifts three element array", function()
		local array1 = { 1, 2, 3 }

		local firstElement = shift(array1)
		jestExpect(array1).toEqual({ 2, 3 })
		jestExpect(firstElement).toEqual(1)
	end)

	it("removes an element from an array", function()
		local myFish = { "angel", "clown", "mandarin", "surgeon" }

		local shifted = shift(myFish)
		jestExpect(myFish).toEqual({ "clown", "mandarin", "surgeon" })
		jestExpect(shifted).toEqual("angel")
	end)

	it("shifts in a loop", function()
		local names = { "Andrew", "Edward", "Paul", "Chris", "John" }
		local nameString = ""
		local name = shift(names)

		while name do
			nameString = nameString .. " " .. name
			name = shift(names)
		end

		jestExpect(nameString).toEqual(" Andrew Edward Paul Chris John")
	end)

	it("shifts empty array", function()
		local empty = {}
		local none = shift(empty)

		jestExpect(empty).toEqual({})
		jestExpect(none).toEqual(nil)
	end)

	if _G.__DEV__ then
		it("throws error on non-array", function()
			local nonarr = "abc"
			-- work around type checking on arguments
			local shift_: any = shift :: any
			jestExpect(function()
				shift_(nonarr)
			end).toThrow("Array.shift called on non-array string")
		end)
	end
end
