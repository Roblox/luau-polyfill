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
	local MIN_SAFE_INTEGER = require(Number.MIN_SAFE_INTEGER)

	local Packages = Number.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("is not equal to the next smaller integer", function()
		jestExpect(MIN_SAFE_INTEGER).never.toEqual(MIN_SAFE_INTEGER - 1)
	end)

	it("is the smallest integer possible", function()
		local unsafeInteger = MIN_SAFE_INTEGER - 1
		jestExpect(unsafeInteger).toEqual(unsafeInteger - 1)
	end)
end
