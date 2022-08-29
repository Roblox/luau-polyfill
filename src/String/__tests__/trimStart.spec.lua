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
	local String = script.Parent.Parent
	local trimStart = require(String.trimStart)

	local LuauPolyfill = String.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("removes spaces at beginning", function()
		jestExpect(trimStart("  abc")).toEqual("abc")
	end)

	it("does not remove spaces at end", function()
		jestExpect(trimStart("abc   ")).toEqual("abc   ")
	end)

	it("removes spaces at only at beginning", function()
		jestExpect(trimStart("  abc   ")).toEqual("abc   ")
	end)

	it("does not remove spaces in the middle", function()
		jestExpect(trimStart("a b c")).toEqual("a b c")
	end)

	it("removes all types of spaces", function()
		jestExpect(trimStart("\r\n\t\f\vabc")).toEqual("abc")
	end)

	it("returns an empty string if there are only spaces", function()
		jestExpect(trimStart("    ")).toEqual("")
	end)
end
