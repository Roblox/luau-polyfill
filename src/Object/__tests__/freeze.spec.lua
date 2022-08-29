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
--!strict
return function()
	local Object = script.Parent.Parent
	local freeze = require(Object.freeze)
	local isFrozen = require(Object.isFrozen)

	local LuauPolyfill = Object.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("should return the same table and isFrozen is true", function()
		local base = {
			a = 1,
		}
		local modified = freeze(base)

		jestExpect(modified).toEqual(base)
		jestExpect(isFrozen(base)).toEqual(true)
	end)

	it("should allow access to any keys that were defined before it's called", function()
		local t = freeze({
			a = 1,
		})

		jestExpect(t.a).toEqual(1)
	end)

	it("should allow access to any keys that were NOT defined before it's called", function()
		local t = freeze({
			a = 1,
		})

		jestExpect((t :: any).b).toBe(nil)
	end)

	it("should not allow mutation of existing values", function()
		local t = freeze({
			a = 1,
		})

		jestExpect(function()
			t.a = 2
		end).toThrow()
	end)

	it("should preserve iteration functionality", function()
		local t = freeze({
			a = 1,
			b = 2,
		})

		local tPairsCopy = {}
		for k, v in pairs(t) do
			tPairsCopy[k] = v
		end

		jestExpect(tPairsCopy).toEqual(t)

		local a = freeze({ "hello", "world" })

		local aIpairsCopy = {}
		for i, v in ipairs(a) do
			aIpairsCopy[i] = v
		end

		jestExpect(aIpairsCopy).toEqual(a)
	end)

	it("should error when setting a nonexistent key", function()
		local t = freeze({
			a = 1,
			b = 2,
		})

		jestExpect(function()
			(t :: any).c = 3
		end).toThrow()
	end)

	it("should error when attempting to freeze a non-table", function()
		-- types on the interface prevent calling with non-table, so we cast away safety to test
		jestExpect(function()
			(freeze :: any)(1)
		end).toThrow()
		jestExpect(function()
			(freeze :: any)("boo")
		end).toThrow()
		jestExpect(function()
			(freeze :: any)(true)
		end).toThrow()
		jestExpect(function()
			(freeze :: any)(false)
		end).toThrow()
	end)

	it("should allow freezing an empty table", function()
		local t = freeze({})
		jestExpect(isFrozen(t)).toBe(true)
	end)
end
