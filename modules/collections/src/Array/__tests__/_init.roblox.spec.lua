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
	local ArrayPath = script.Parent.Parent
	local Array = require(ArrayPath)
	local Packages = ArrayPath.Parent.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	it("should expose concat method", function()
		jestExpect(typeof(Array.concat)).toBe("function")
	end)

	it("should expose every method", function()
		jestExpect(typeof(Array.every)).toBe("function")
	end)

	it("should expose filter method", function()
		jestExpect(typeof(Array.filter)).toBe("function")
	end)

	it("should expose find method", function()
		jestExpect(typeof(Array.find)).toBe("function")
	end)

	it("should expose findIndex method", function()
		jestExpect(typeof(Array.findIndex)).toBe("function")
	end)

	it("should expose flat method", function()
		jestExpect(typeof(Array.flat)).toBe("function")
	end)

	it("should expose flatMap method", function()
		jestExpect(typeof(Array.flatMap)).toBe("function")
	end)

	it("should expose forEach method", function()
		jestExpect(typeof(Array.forEach)).toBe("function")
	end)

	it("should expose from method", function()
		jestExpect(typeof(Array.from)).toBe("function")
	end)

	it("should expose includes method", function()
		jestExpect(typeof(Array.includes)).toBe("function")
	end)

	it("should expose indexOf method", function()
		jestExpect(typeof(Array.indexOf)).toBe("function")
	end)

	it("should expose isArray method", function()
		jestExpect(typeof(Array.isArray)).toBe("function")
	end)

	it("should expose join method", function()
		jestExpect(typeof(Array.join)).toBe("function")
	end)

	it("should expose map method", function()
		jestExpect(typeof(Array.map)).toBe("function")
	end)

	it("should expose reduce method", function()
		jestExpect(typeof(Array.reduce)).toBe("function")
	end)

	it("should expose reverse method", function()
		jestExpect(typeof(Array.reverse)).toBe("function")
	end)

	it("should expose shift method", function()
		jestExpect(typeof(Array.shift)).toBe("function")
	end)

	it("should expose slice method", function()
		jestExpect(typeof(Array.slice)).toBe("function")
	end)

	it("should expose some method", function()
		jestExpect(typeof(Array.some)).toBe("function")
	end)

	it("should expose sort method", function()
		jestExpect(typeof(Array.sort)).toBe("function")
	end)

	it("should expose splice method", function()
		jestExpect(typeof(Array.splice)).toBe("function")
	end)

	it("should expose unshoft method", function()
		jestExpect(typeof(Array.concat)).toBe("function")
	end)
end
