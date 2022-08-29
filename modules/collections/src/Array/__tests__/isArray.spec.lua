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
-- Tests partially based on examples from:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/isArray
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local types = require(Packages.ES7Types)
	type Array<T> = types.Array<T>
	local isArray = require(Array.isArray)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns false for non-tables", function()
		jestExpect(isArray(nil)).toEqual(false)
		jestExpect(isArray(1)).toEqual(false)
		jestExpect(isArray("hello")).toEqual(false)
		jestExpect(isArray(function() end)).toEqual(false)
		jestExpect(isArray(newproxy(false))).toEqual(false)
	end)

	it("returns false for tables with non-number keys", function()
		jestExpect(isArray({ hello = 1 })).toEqual(false)
		jestExpect(isArray({ [function() end] = 1 })).toEqual(false)
		jestExpect(isArray({ [newproxy(false)] = 1 })).toEqual(false)
	end)

	it("returns false for a table with non-integer key", function()
		jestExpect(isArray({ [0.5] = true })).toEqual(false)
	end)

	it("returns false for a table with a key equal to zero", function()
		jestExpect(isArray({ [0] = true })).toEqual(false)
	end)

	it("returns true for an empty table", function()
		jestExpect(isArray({})).toEqual(true)
	end)

	it("returns false for sparse arrays", function()
		jestExpect(isArray({
			[1] = "1",
			[3] = "3",
		})).toEqual(false)
		jestExpect(isArray({
			[2] = "2",
			[3] = "3",
		})).toEqual(false)
	end)

	it("returns false for tables with non-positive-number keys", function()
		jestExpect(isArray({
			[-2] = "-2",
			[2] = "2",
			[3] = "3",
		})).toEqual(false)
	end)

	it("returns true for valid arrays", function()
		jestExpect(isArray({ "a", "b", "c" })).toEqual(true)
		jestExpect(isArray({ 1, 2, 3 })).toEqual(true)
		jestExpect(isArray({ 1, "b", function() end } :: Array<any>)).toEqual(true)
	end)
end
