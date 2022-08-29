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
	local isSafeInteger = require(Number.isSafeInteger)

	local Packages = Number.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns true when given 3", function()
		jestExpect(isSafeInteger(3)).toEqual(true)
	end)

	it("returns true when given math.pow(2, 53) - 1", function()
		jestExpect(isSafeInteger(math.pow(2, 53) - 1)).toEqual(true)
	end)

	it("returns true when given 3.0", function()
		jestExpect(isSafeInteger(3.0)).toEqual(true)
	end)

	it("returns false when given math.pow(2, 53)", function()
		jestExpect(isSafeInteger(math.pow(2, 53))).toEqual(false)
	end)

	it("returns false when given nan", function()
		jestExpect(isSafeInteger(0 / 0)).toEqual(false)
	end)

	it("returns false when given inf", function()
		jestExpect(isSafeInteger(math.huge)).toEqual(false)
	end)

	it("returns false when given '3'", function()
		jestExpect(isSafeInteger("3" :: any)).toEqual(false)
	end)

	it("returns false when given 3.1", function()
		jestExpect(isSafeInteger(3.1)).toEqual(false)
	end)
end
