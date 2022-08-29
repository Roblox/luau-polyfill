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
	local Object = script.Parent.Parent
	local Packages = Object.Parent.Parent

	local values = require(Object.values)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns the values of a table", function()
		local result = values({
			foo = "bar",
			baz = "zoo",
		})
		table.sort(result)
		jestExpect(result).toEqual({ "bar", "zoo" })
	end)

	it("returns the values of an array-like table", function()
		local result = values({ "bar", "foo" })
		table.sort(result)
		jestExpect(result).toEqual({ "bar", "foo" })
	end)

	it("returns an array of character given a string", function()
		jestExpect(values("bar")).toEqual({ "b", "a", "r" })
	end)

	-- Luau types don't allow this to happen, figure out how to enable this test with type stripped
	itSKIP("throws given nil", function()
		jestExpect(function()
			-- values(nil)
		end).toThrow("cannot extract values from a nil value")
	end)
end
