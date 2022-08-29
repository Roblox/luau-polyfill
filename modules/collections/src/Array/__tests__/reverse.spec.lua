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
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local reverse = require(Array.reverse)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns the same array", function()
		local array = {}
		jestExpect(reverse(array)).toBe(array)
	end)

	it("reverses the members", function()
		local numbers = { 4, 5, 10, 88 }
		reverse(numbers)
		jestExpect(numbers).toEqual({ 88, 10, 5, 4 })
	end)
end
