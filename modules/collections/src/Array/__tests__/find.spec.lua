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

	local find = require(Array.find)
	local types = require(Packages.ES7Types)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	type Array<T> = types.Array<T>

	local function returnTrue()
		return true
	end

	local function returnFalse()
		return false
	end

	it("returns nil if the array is empty", function()
		jestExpect(find({}, returnTrue)).toEqual(nil)
	end)

	it("returns nil if the predicate is always false", function()
		jestExpect(find({ 1, 2, 3 }, returnFalse)).toEqual(nil)
	end)

	it("returns the first element where the predicate is true", function()
		local result = find({ 3, 4, 5, 6 }, function(element)
			return element % 2 == 0
		end)
		jestExpect(result).toEqual(4)
	end)

	it("passes the element, its index and the array to the predicate", function()
		local arguments = nil
		local array = { "foo" }
		find(array, function(...)
			arguments = { ... }
			return false
		end)
		jestExpect(arguments).toEqual({ "foo", 1, array } :: Array<any>)
	end)
end
