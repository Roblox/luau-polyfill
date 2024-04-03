local toJSBoolean = require("../toJSBoolean")

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local it = JestGlobals.it

-- https://developer.mozilla.org/en-US/docs/Glossary/Falsy
it("tests javascript falsy values", function()
	jestExpect(toJSBoolean(false)).toEqual(false)
	jestExpect(toJSBoolean(0)).toEqual(false)
	jestExpect(toJSBoolean(-0)).toEqual(false)
	jestExpect(toJSBoolean("")).toEqual(false)
	jestExpect(toJSBoolean(nil)).toEqual(false)
	jestExpect(toJSBoolean(0 / 0)).toEqual(false)
end)

-- https://developer.mozilla.org/en-US/docs/Glossary/Truthy
it("tests javascript truthy values", function()
	jestExpect(toJSBoolean(true)).toEqual(true)
	jestExpect(toJSBoolean({})).toEqual(true)
	jestExpect(toJSBoolean(42)).toEqual(true)
	jestExpect(toJSBoolean("0")).toEqual(true)
	jestExpect(toJSBoolean("false")).toEqual(true)
	jestExpect(toJSBoolean(DateTime.now())).toEqual(true)
	jestExpect(toJSBoolean(-42)).toEqual(true)
	jestExpect(toJSBoolean(3.14)).toEqual(true)
	jestExpect(toJSBoolean(-3.14)).toEqual(true)
	jestExpect(toJSBoolean(math.huge)).toEqual(true)
	jestExpect(toJSBoolean(-1 / 0)).toEqual(true)
end)
