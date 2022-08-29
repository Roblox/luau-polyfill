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
-- tests inspired by MDN documentation: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substr
return function()
	local String = script.Parent.Parent
	local substr = require(String.substr)

	local LuauPolyfill = String.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("goes to end of string when number of characters is not supplied", function()
		jestExpect(substr("Roblox", 2)).toEqual("oblox")
	end)

	it("wraps to end of string when negative index is supplied", function()
		jestExpect(substr("Roblox", -1)).toEqual("x")
		jestExpect(substr("Roblox", -2)).toEqual("ox")
	end)

	it("captures only the correct characters when number of characters is supplied", function()
		jestExpect(substr("Roblox", 2, 2)).toEqual("ob")
	end)

	it("returns empty string when number of characters is less than 1", function()
		jestExpect(substr("Roblox", 2, 0)).toEqual("")
		jestExpect(substr("Roblox", 2, -2)).toEqual("")
	end)
end
