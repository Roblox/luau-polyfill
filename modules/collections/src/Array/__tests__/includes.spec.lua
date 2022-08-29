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
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes
return function()
	local Array = script.Parent.Parent
	local Packages = Array.Parent.Parent

	local includes = require(Array.includes)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local beasts = { "ant", "bison", "camel", "duck", "bison" }

	it("finds an element", function()
		jestExpect(includes(beasts, "bison")).toBe(true)
	end)

	it("does not find element when index after its position is provided", function()
		jestExpect(includes(beasts, "ant", 3)).toBe(false)
	end)

	it("returns false when the fromIndex is too large", function()
		jestExpect(includes(beasts, "camel", 6)).toBe(false)
	end)

	it("accepts a negative fromIndex, and subtracts it from the total length", function()
		jestExpect(includes(beasts, "duck", -1)).toBe(true)
		jestExpect(includes(beasts, "camel", -2)).toBe(true)
		jestExpect(includes(beasts, "camel", -1)).toBe(false)
	end)

	it("accepts a 0 fromIndex (special case for Lua's 1-index arrays) and starts at the end", function()
		jestExpect(includes(beasts, "bison", 0)).toEqual(true)
	end)

	it("starts at the beginning when it receives a too-large negative fromIndex", function()
		jestExpect(includes(beasts, "bison", -10)).toBe(true)
		jestExpect(includes(beasts, "ant", -10)).toBe(true)
	end)
end
