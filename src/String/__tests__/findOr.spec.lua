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
	local String = script.Parent.Parent
	local Packages = String.Parent.Parent
	local findOr = require(String.findOr)
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("returns nil when not found", function()
		local str = "abc"
		local terms = { "d" }
		local match = findOr(str, terms)

		jestExpect(match).toEqual(nil)
	end)

	it("returns matched element", function()
		local str = "abc"
		local terms = { "b" }
		local actual = findOr(str, terms)
		local expected = {
			index = 2,
			match = "b",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns matched element when its a Lua pattern % character", function()
		local str = "a%c"
		local terms = { "%" }
		local actual = findOr(str, terms)
		local expected = {
			index = 2,
			match = "%",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns matched element when its a Lua pattern . character", function()
		local str = "a.c"
		local terms = { "." }
		local actual = findOr(str, terms)
		local expected = {
			index = 2,
			match = ".",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns 2nd instance of matched element after start position", function()
		local str = "abcb"
		local terms = { "b" }
		local actual = findOr(str, terms, 3)
		local expected = {
			index = 4,
			match = "b",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns if any items match", function()
		local str = "_rn_r_n"
		local terms = { "rn", "r", "n" }
		local actual = findOr(str, terms)
		local expected = {
			index = 2,
			match = "rn",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns 2nd instance if any items match after start position", function()
		local str = "_rn_r_n"
		local terms = { "rn", "r", "n" }
		local actual = findOr(str, terms, 4)
		local expected = {
			index = 5,
			match = "r",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns matched multiple characters", function()
		local str = "abbbc"
		local terms = { "b+" }
		local actual = findOr(str, terms)
		local expected = {
			index = 2,
			match = "bbb",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns matched element when multi-byte character present in the source string", function()
		local str = "\u{FEFF}abbbc"
		local terms = { "b" }
		local actual = findOr(str, terms)
		local expected = {
			index = 3,
			match = "b",
		}
		jestExpect(actual).toEqual(expected)
	end)

	it("returns matched element after init index when multi-byte character present in the source string", function()
		local str = "\u{FEFF}ababc"
		local terms = { "b" }
		local actual = findOr(str, terms, 4)
		local expected = {
			index = 5,
			match = "b",
		}
		jestExpect(actual).toEqual(expected)
	end)
end
