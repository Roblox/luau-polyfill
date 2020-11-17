-- FIXME: roblox-cli has special, hard-coded types for TestEZ that break when we
-- use custom matchers added via `expect.extend`
--!nocheck
return function()
	local TestMatchers = script.Parent.TestMatchers
	local toEqual = require(TestMatchers.toEqual)
	local toThrow = require(TestMatchers.toThrow)

	beforeAll(function()
		expect.extend({
			-- FIXME: Replace this with jest-roblox builtins
			toEqual = toEqual,
			toThrow = toThrow,
		})
	end)
end