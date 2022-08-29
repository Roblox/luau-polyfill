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
	local preventExtensions = require(Object.preventExtensions)

	local LuauPolyfill = Object.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("should return the same table", function()
		local base = {
			a = 1,
		}
		local modified = preventExtensions(base)

		jestExpect(modified).toEqual(base)
	end)

	it("should allow access to any keys that were defined before it's called", function()
		local t = preventExtensions({
			a = 1,
		})

		jestExpect(t.a).toEqual(1)
	end)

	it("should allow mutation of existing values", function()
		local t = preventExtensions({
			a = 1,
		})

		t.a = 2
		jestExpect(t.a).toEqual(2)
	end)

	it("should preserve iteration functionality", function()
		local t = preventExtensions({
			a = 1,
			b = 2,
		})

		local tPairsCopy = {}
		for k, v in pairs(t) do
			tPairsCopy[k] = v
		end

		jestExpect(tPairsCopy).toEqual(t)

		local a = preventExtensions({ "hello", "world" })

		local aIpairsCopy = {}
		for i, v in ipairs(a) do
			aIpairsCopy[i] = v
		end

		jestExpect(aIpairsCopy).toEqual(a)
	end)

	it("should error when setting a nonexistent key", function()
		local t = preventExtensions({
			a = 1,
			b = 2,
		})

		jestExpect(function()
			t.c = 3
		end).toThrow()
	end)
end
