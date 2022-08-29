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
	local Array = script.Parent.Parent
	local Collections = Array.Parent
	local Packages = Collections.Parent

	local join = require(Array.join)
	local Set = require(Collections.Set)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	describe("Join", function()
		local arr = { "Wind", "Water", "Fire" }

		it("should join strings arrays without specified separator", function()
			jestExpect(join(arr)).toEqual("Wind,Water,Fire")
		end)

		it("should join strings arrays with specified separator", function()
			jestExpect(join(arr, ", ")).toEqual("Wind, Water, Fire")
			jestExpect(join(arr, " + ")).toEqual("Wind + Water + Fire")
			jestExpect(join(arr, "")).toEqual("WindWaterFire")
		end)

		it("should join empty array", function()
			jestExpect(join({})).toEqual("")
			jestExpect(join({}, ", ")).toEqual("")
			jestExpect(join({}, " + ")).toEqual("")
			jestExpect(join({}, "")).toEqual("")
		end)

		it("should not add separator for array with single element", function()
			jestExpect(join({ "foo" }, ", ")).toEqual("foo")
			jestExpect(join({ "foo" }, " + ")).toEqual("foo")
			jestExpect(join({ "foo" }, "")).toEqual("foo")
		end)

		it("should tostring() elements of non-string arrays", function()
			jestExpect(join({ 1, 2, 3 })).toEqual("1,2,3")
			jestExpect(join({ { foo = 90210 } })).toContain("table")
			jestExpect(join({ Set.new(), Set.new() })).toEqual("Set [],Set []")
		end)
	end)
end
