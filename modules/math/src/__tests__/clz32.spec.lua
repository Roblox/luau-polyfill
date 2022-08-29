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
	local Math = script.Parent.Parent
	local clz32 = require(Math.clz32)

	local Packages = Math.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("gives the number of leading zero of powers of 2", function()
		for i = 1, 32 do
			local value = 2 ^ (i - 1)
			local expected = 32 - i
			jestExpect(clz32(value)).toEqual(expected)
		end
	end)

	it("gives the number of leading zeros of random values", function()
		for _ = 1, 100 do
			local power = math.random(1, 31)
			local powerValue = 2 ^ power
			local value = powerValue + math.random(1, powerValue - 1)

			jestExpect(clz32(value)).toEqual(31 - power)
		end
	end)
end
