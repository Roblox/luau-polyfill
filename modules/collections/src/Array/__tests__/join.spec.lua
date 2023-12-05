return function()
	local join = require("../join")
	local Set = require("../../Set")

	local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
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
