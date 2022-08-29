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
	local Number = script.Parent.Parent
	local isNaN = require(Number.isNaN)

	local LuauPolyfill = Number.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns true when given 0/0", function()
		jestExpect(isNaN(0 / 0)).toEqual(true)
	end)

	it('returns false when given "nan"', function()
		jestExpect(isNaN("nan")).toEqual(false)
	end)

	it("returns false when given nil", function()
		jestExpect(isNaN(nil)).toEqual(false)
	end)

	it("returns false when given {}", function()
		jestExpect(isNaN({})).toEqual(false)
	end)

	it('returns false when given "blabla"', function()
		jestExpect(isNaN("blabla")).toEqual(false)
	end)

	it("returns false when given true", function()
		jestExpect(isNaN(true)).toEqual(false)
	end)

	it("returns false when given 37", function()
		jestExpect(isNaN(37)).toEqual(false)
	end)

	it("returns false when given an empty string", function()
		jestExpect(isNaN("")).toEqual(false)
	end)
end
