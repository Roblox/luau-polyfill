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
-- Tests adapted directly from examples at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice
return function()
	local Array = script.Parent.Parent
	local LuauPolyfill = Array.Parent
	local types = require(LuauPolyfill.types)
	type Array<T> = types.Array<T>
	local slice = require(Array.slice)

	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("Invalid argument", function()
		jestExpect(function()
			-- Luau analysis correctly warns and prevents this abuse case, typecast to force it through
			slice((nil :: any) :: Array<any>, 1)
		end).toThrow()
	end)

	it("Return the whole array", function()
		local animals = { "ant", "bison", "camel", "duck", "elephant" }
		local array_slice = slice(animals)
		jestExpect(array_slice).toEqual({
			"ant",
			"bison",
			"camel",
			"duck",
			"elephant",
		})
	end)

	it("Return from index 3 to end", function()
		local animals = { "ant", "bison", "camel", "duck", "elephant" }
		local array_slice = slice(animals, 3)
		jestExpect(array_slice).toEqual({ "camel", "duck", "elephant" })
	end)

	it("Return from index 3 to 5", function()
		local animals = { "ant", "bison", "camel", "duck", "elephant" }
		local array_slice = slice(animals, 3, 5)
		jestExpect(array_slice).toEqual({ "camel", "duck" })
	end)

	it("Return from index 2 to index 6 (out of bounds)", function()
		local animals = { "ant", "bison", "camel", "duck", "elephant" }
		local array_slice = slice(animals, 2, 6)
		jestExpect(array_slice).toEqual({ "bison", "camel", "duck", "elephant" })
	end)

	describe("Negative indices", function()
		it("Return from index 0 to end", function()
			local animals = { "ant", "bison", "camel", "duck", "elephant" }
			local array_slice = slice(animals, 0)
			jestExpect(array_slice).toEqual({ "elephant" })
		end)

		it("Return from index -1 to 0", function()
			local animals = { "ant", "bison", "camel", "duck", "elephant" }
			local array_slice = slice(animals, -1, 0)
			jestExpect(array_slice).toEqual({ "duck" })
		end)
	end)

	describe("Return empty array", function()
		it("Start index out of bounds", function()
			local animals = { "ant", "bison", "camel", "duck", "elephant" }
			local array_slice = slice(animals, 10)
			jestExpect(array_slice).toEqual({})
		end)

		it("Start index after end index", function()
			local animals = { "ant", "bison", "camel", "duck", "elephant" }
			local array_slice = slice(animals, 2, 1)
			jestExpect(array_slice).toEqual({})
		end)
	end)
end
