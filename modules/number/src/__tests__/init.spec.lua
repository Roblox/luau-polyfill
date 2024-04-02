local Number = require("../init")

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local it = JestGlobals.it

it("has MAX_SAFE_INTEGER constant", function()
	jestExpect(Number.MAX_SAFE_INTEGER).toEqual(jestExpect.any("number"))
end)

it("has MIN_SAFE_INTEGER constant", function()
	jestExpect(Number.MIN_SAFE_INTEGER).toEqual(jestExpect.any("number"))
end)
