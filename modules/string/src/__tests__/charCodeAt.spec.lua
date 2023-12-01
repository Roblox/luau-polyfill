return function()
	local charCodeAt = require("../charCodeAt")

	local Number = require("@pkg/number")
	local JestGlobals = require("@pkg/jest-globals")
	local jestExpect = JestGlobals.expect

	describe("charCodeAt", function()
		it("returns 97 for a", function()
			local body = "apple"
			local actual = charCodeAt(body, 1)
			jestExpect(actual).toBe(97)
		end)

		it("returns 97 for a when not the first character", function()
			local body = "_apple"
			local actual = charCodeAt(body, 2)
			jestExpect(actual).toBe(97)
		end)

		it("returns 97 for a when not the first character and is the last character", function()
			local body = "_a"
			local actual = charCodeAt(body, 2)
			jestExpect(actual).toBe(97)
		end)

		it("returns special characters", function()
			-- test chars
			jestExpect(charCodeAt(" ", 1)).toBe(32)
			jestExpect(charCodeAt(",", 1)).toBe(44)

			-- test special chars
			jestExpect(charCodeAt("\t", 1)).toBe(9)
			jestExpect(charCodeAt("\n", 1)).toBe(10)

			-- test unicode (BOM)
			jestExpect(0xfeff).toBe(65279)

			local bomStringFromChar = utf8.char(0xfeff)
			local bomStringFromEncoding = "\u{feff}"

			jestExpect(charCodeAt(bomStringFromChar, 1)).toBe(65279)
			jestExpect(charCodeAt(bomStringFromEncoding, 1)).toBe(65279)
		end)

		it("handle chars above 7-bit ascii", function()
			-- two bytes
			-- first byte (81)  - has high bit set
			-- second byte (23) - must have second byte

			-- local body = utf8.char(0x8123) .. " foo"
			local body = "\u{8123}a"

			jestExpect(charCodeAt(body, 1)).toBe(0x8123)
			jestExpect(charCodeAt(body, 2)).toBe(97)
		end)

		it("returns NaN when position is out of bounds", function()
			local body = "\u{8123}a"

			jestExpect(charCodeAt(body, 0)).toBe(Number.NaN)
			jestExpect(charCodeAt(body, 3)).toBe(Number.NaN)
			jestExpect(charCodeAt(body, 100)).toBe(Number.NaN)
		end)

		it("accepts a non-number index as an index of 1", function()
			local body = "\u{8123}a"
			local charCodeAt_: any = charCodeAt :: any
			jestExpect(charCodeAt_(body, "a")).toBe(0x8123)
			jestExpect(charCodeAt_(body, nil)).toBe(0x8123)
		end)
	end)
end
