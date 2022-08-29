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
	local NumberModule = script.Parent.Parent
	local Number = require(NumberModule)

	local LuauPolyfill = NumberModule.Parent
	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("has MAX_SAFE_INTEGER constant", function()
		jestExpect(Number.MAX_SAFE_INTEGER).toEqual(jestExpect.any("number"))
	end)

	it("has MIN_SAFE_INTEGER constant", function()
		jestExpect(Number.MIN_SAFE_INTEGER).toEqual(jestExpect.any("number"))
	end)
end
