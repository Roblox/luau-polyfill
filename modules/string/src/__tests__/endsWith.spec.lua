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
	local Packages = String.Parent

	local endsWith = require(String.endsWith)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("is true if the string ends with the given substring", function()
		jestExpect(endsWith("foo", "oo")).toEqual(true)
	end)

	it("is true if the string ends with the given substring at the given position", function()
		jestExpect(endsWith("hello", "ll", 4)).toEqual(true)
	end)

	it("is false if the string does not end with the given substring", function()
		jestExpect(endsWith("foo", "b")).toEqual(false)
	end)

	it("is true if the given length is greater than the string and it ends with the given substring", function()
		jestExpect(endsWith("foo", "oo", 10)).toEqual(true)
	end)

	it("is false if the given length is lower than one", function()
		jestExpect(endsWith("foo", "o", -4)).toEqual(false)
	end)

	it("is false if the substring is longer than the string", function()
		jestExpect(endsWith("ooo", "oooo")).toEqual(false)
	end)

	it("is true if the substring is empty", function()
		jestExpect(endsWith("foo", "")).toEqual(true)
		jestExpect(endsWith("foo", "", 10)).toEqual(true)
		jestExpect(endsWith("foo", "", -10)).toEqual(true)
	end)

	it("passes the examples on MDN", function()
		local str = "To be, or not to be, that is the question."

		jestExpect(endsWith(str, "question.")).toEqual(true)
		jestExpect(endsWith(str, "to be")).toEqual(false)
		jestExpect(endsWith(str, "to be", 19)).toEqual(true)
	end)
end
