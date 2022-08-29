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
	local isInteger = require(Number.isInteger)

	local LuauPolyfill = Number.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns true when given 0", function()
		jestExpect(isInteger(0)).toEqual(true)
	end)

	it("returns true when given 1", function()
		jestExpect(isInteger(1)).toEqual(true)
	end)

	it("returns true when given -100000", function()
		jestExpect(isInteger(-100000)).toEqual(true)
	end)

	it("returns true when given 99999999999999999999999", function()
		jestExpect(isInteger(99999999999999999999999)).toEqual(true)
	end)

	it("returns true when given 5.0", function()
		jestExpect(isInteger(5.0)).toEqual(true)
	end)

	it("returns false when given 0.1", function()
		jestExpect(isInteger(0.1)).toEqual(false)
	end)

	it("returns false when given math.pi", function()
		jestExpect(isInteger(math.pi)).toEqual(false)
	end)

	it("returns false when given nan", function()
		jestExpect(isInteger(0 / 0)).toEqual(false)
	end)

	it("returns false when given inf", function()
		jestExpect(isInteger(math.huge)).toEqual(false)
	end)

	it("returns false when given '10'", function()
		jestExpect(isInteger("10")).toEqual(false)
	end)
end
