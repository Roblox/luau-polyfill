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
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local indexOf = require(Array.indexOf)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local beasts = { "ant", "bison", "camel", "duck", "bison" }

	it("returns the index of the first occurrence of an element", function()
		jestExpect(indexOf(beasts, "bison")).toEqual(2)
	end)

	it("begins at the start index when provided", function()
		jestExpect(indexOf(beasts, "bison", 3)).toEqual(5)
	end)

	it("returns -1 when the value isn't present", function()
		jestExpect(indexOf(beasts, "giraffe")).toEqual(-1)
	end)

	it("returns -1 when the fromIndex is too large", function()
		jestExpect(indexOf(beasts, "camel", 6)).toEqual(-1)
	end)

	it("accepts a negative fromIndex, and subtracts it from the total length", function()
		jestExpect(indexOf(beasts, "bison", -4)).toEqual(2)
		jestExpect(indexOf(beasts, "bison", -2)).toEqual(5)
		jestExpect(indexOf(beasts, "ant", -2)).toEqual(-1)
	end)

	it("accepts a 0 fromIndex (special case for Lua's 1-index arrays) and starts at the end", function()
		jestExpect(indexOf(beasts, "bison", 0)).toEqual(5)
	end)

	it("starts at the beginning when it receives a too-large negative fromIndex", function()
		jestExpect(indexOf(beasts, "bison", -10)).toEqual(2)
		jestExpect(indexOf(beasts, "ant", -10)).toEqual(1)
	end)

	it("uses strict equality", function()
		local firstObject = { x = 1 }
		local objects = {
			firstObject,
			{ x = 2 },
			{ x = 3 },
		}
		jestExpect(indexOf(objects, { x = 2 })).toEqual(-1)
		jestExpect(indexOf(objects, firstObject)).toEqual(1)
	end)
end
