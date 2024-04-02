local MIN_SAFE_INTEGER = require("../MIN_SAFE_INTEGER")

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local it = JestGlobals.it

it("is not equal to the next smaller integer", function()
	jestExpect(MIN_SAFE_INTEGER).never.toEqual(MIN_SAFE_INTEGER - 1)
end)

it("is the smallest integer possible", function()
	local unsafeInteger = MIN_SAFE_INTEGER - 1
	jestExpect(unsafeInteger).toEqual(unsafeInteger - 1)
end)
