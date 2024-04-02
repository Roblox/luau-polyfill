local Error = require("../init")
type Error = Error.Error
local RegExp = require("@pkg/luau-regexp")
local extends = require("../../init").extends
local instanceof = require("../../init").instanceof
local Object = require("@pkg/@jsdotlua/collections").Object

local JestGlobals = require("@pkg/@jsdotlua/jest-globals")
local jestExpect = JestGlobals.expect
local it = JestGlobals.it
local describe = JestGlobals.describe

local MyError = extends(Error, "MyError", function(self, message)
	Object.assign(self, Error.new(message))
	self.name = "MyError"
end)

local YourError = extends(MyError, "YourError", function(self, message)
	Object.assign(self, Error.new(message))
	self.name = "YourError"
end)

it("accepts a message value as an argument", function()
	local err = Error("Some message")

	jestExpect(err.message).toEqual("Some message")
end)

it("defaults the `name` field to 'Error'", function()
	local err = Error("")

	jestExpect(err.name).toEqual("Error")
end)

it("gets passed through the `error` builtin properly", function()
	local err = Error("Throwing an error")
	local ok, result = pcall(function()
		error(err)
	end)

	jestExpect(ok).toEqual(false)
	jestExpect(result).toEqual(err)
end)

it("checks that Error is a class according to our inheritance standard", function()
	local err = Error("Test")
	jestExpect(instanceof(err, Error)).toEqual(true)
end)

it("checks the inheritance of Error", function()
	local inst: Error = MyError("my error message")

	jestExpect(inst.message).toEqual("my error message")
	jestExpect(inst.name).toEqual("MyError")

	-- inheritance checks
	jestExpect(instanceof(inst, MyError)).toEqual(true)
	jestExpect(instanceof(inst, Error)).toEqual(true)
end)

it("checks the inheritance of a sub error", function()
	local inst: Error = YourError("your error message")

	jestExpect(inst.message).toEqual("your error message")
	jestExpect(inst.name).toEqual("YourError")

	-- inheritance checks
	jestExpect(instanceof(inst, YourError))
	jestExpect(instanceof(inst, MyError)).toEqual(true)
	jestExpect(instanceof(inst, Error)).toEqual(true)
end)

it("evaluates both toString methods", function()
	jestExpect(tostring(Error)).toEqual("Error")
	jestExpect(tostring(Error("test"))).toEqual("Error: test")

	jestExpect(tostring(MyError)).toEqual("MyError")
	jestExpect(tostring(MyError("my test"))).toEqual("MyError: my test")

	jestExpect(tostring(YourError)).toEqual("YourError")
	jestExpect(tostring(YourError("your test"))).toEqual("YourError: your test")
end)

it("checks Error stack field", function()
	local lineNumber = (debug.info(1, "l") :: number) + 1
	local err = Error("test stack for Error()")
	local topLineRegExp = RegExp("Error.__tests__\\.Error\\.spec:" .. tostring(lineNumber))

	jestExpect(topLineRegExp:test(err.stack)).toEqual(true)

	local lineNumber2 = (debug.info(1, "l") :: number) + 1
	local err2 = Error.new("test stack for Error.new()")
	local topLineRegExp2 = RegExp("Error.__tests__\\.Error\\.spec:" .. tostring(lineNumber2))

	jestExpect(topLineRegExp2:test(err2.stack)).toEqual(true)
end)

it("checks Error stack field contains error message", function()
	local err = Error("test stack for Error()")
	local err2 = Error.new("test stack for Error.new()")

	local topLineRegExp = RegExp("^.*test stack for Error()")
	local topLineRegExp2 = RegExp("^.*test stack for Error.new()")

	jestExpect(topLineRegExp:test(err.stack)).toEqual(true)
	jestExpect(topLineRegExp2:test(err2.stack)).toEqual(true)
end)

it("checks Error stack field doesn't contains stack from callable table", function()
	local err = Error("test stack for Error()")

	local topLineRegExp = RegExp("Error:\\d+ function __call")

	jestExpect(topLineRegExp:test(err.stack)).toEqual(false)
end)

it("checks Error stack field doesn't contains stack from Error.new function", function()
	local err = Error.new("test stack for Error.new()")

	local topLineRegExp = RegExp("Error:\\d+ function new")

	jestExpect(topLineRegExp:test(err.stack)).toEqual(false)
end)

it("checks Error stack field contains error name at the beginning", function()
	local err = Error("test stack for Error()")
	local err2 = Error.new("test stack for Error.new()")

	local topLineRegExp = RegExp("^Error: test stack for Error()")
	local topLineRegExp2 = RegExp("^Error: test stack for Error.new()")

	jestExpect(topLineRegExp:test(err.stack)).toEqual(true)
	jestExpect(topLineRegExp2:test(err2.stack)).toEqual(true)
end)

it.skip(
	"checks Error stack field contains error name at the beginning if name is modified before accessing stack",
	function()
		local err = Error("test stack for Error()")
		local err2 = Error.new("test stack for Error.new()")
		err.name = "MyError"
		err2.name = "MyError"

		local topLineRegExp = RegExp("^MyError: test stack for Error()")
		local topLineRegExp2 = RegExp("^MyError: test stack for Error.new()")

		jestExpect(topLineRegExp:test(err.stack)).toEqual(true)
		jestExpect(topLineRegExp2:test(err2.stack)).toEqual(true)
	end
)

it("checks default Error message field", function()
	jestExpect(Error().message).toEqual("")
end)

it("prints 'Error' for an empty Error", function()
	jestExpect(tostring(Error())).toEqual("Error")
end)

describe("Error.captureStackTrace", function()
	local function createErrorNew()
		return Error.new("error message new function")
	end

	local function createErrorCallable()
		return Error("error message callable table")
	end

	local function myCaptureStacktrace(err: Error)
		Error.captureStackTrace(err)
	end

	local function myCaptureStacktraceNested0(err: Error)
		local function f1()
			local function f2()
				Error.captureStackTrace(err)
			end
			f2()
		end
		f1()
	end

	local function myCaptureStacktraceNested1(err: Error)
		local function f1()
			local function f2()
				Error.captureStackTrace(err, f1)
			end
			f2()
		end
		f1()
	end

	local function myCaptureStacktraceNested2(err: Error)
		local function f1()
			local function f2()
				Error.captureStackTrace(err, f2)
			end
			f2()
		end
		f1()
	end

	it("should capture functions stacktrace - Error.new", function()
		local err = createErrorNew()

		local stacktraceRegex1 = RegExp("function createErrorNew")
		local stacktraceRegex2 = RegExp("function createErrorCallable")
		local stacktraceRegex3 = RegExp("function myCaptureStacktrace")

		jestExpect(stacktraceRegex1:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegex2:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegex3:test(err.stack)).toEqual(false)

		myCaptureStacktrace(err)

		jestExpect(stacktraceRegex1:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegex2:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegex3:test(err.stack)).toEqual(true)
	end)

	it("should capture functions stacktrace - Error", function()
		local err = createErrorCallable()

		local stacktraceRegex1 = RegExp("function createErrorNew")
		local stacktraceRegex2 = RegExp("function createErrorCallable")
		local stacktraceRegex3 = RegExp("function myCaptureStacktrace")

		jestExpect(stacktraceRegex1:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegex2:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegex3:test(err.stack)).toEqual(false)

		myCaptureStacktrace(err)

		jestExpect(stacktraceRegex1:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegex2:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegex3:test(err.stack)).toEqual(true)
	end)

	it("should capture functions stacktrace with option - Error.new", function()
		local err = createErrorNew()
		local stacktraceRegex = RegExp("function myCaptureStacktraceNested")
		local stacktraceRegexF1 = RegExp("function f1")
		local stacktraceRegexF2 = RegExp("function f2")

		myCaptureStacktraceNested0(err)

		jestExpect(stacktraceRegex:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF1:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF2:test(err.stack)).toEqual(true)

		myCaptureStacktraceNested1(err)

		jestExpect(stacktraceRegex:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF1:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegexF2:test(err.stack)).toEqual(false)

		myCaptureStacktraceNested2(err)

		jestExpect(stacktraceRegex:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF1:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF2:test(err.stack)).toEqual(false)
	end)

	it("should capture functions stacktrace with option - Error", function()
		local err = createErrorCallable()
		local stacktraceRegex = RegExp("function myCaptureStacktraceNested")
		local stacktraceRegexF1 = RegExp("function f1")
		local stacktraceRegexF2 = RegExp("function f2")

		myCaptureStacktraceNested0(err)

		jestExpect(stacktraceRegex:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF1:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF2:test(err.stack)).toEqual(true)

		myCaptureStacktraceNested1(err)

		jestExpect(stacktraceRegex:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF1:test(err.stack)).toEqual(false)
		jestExpect(stacktraceRegexF2:test(err.stack)).toEqual(false)

		myCaptureStacktraceNested2(err)

		jestExpect(stacktraceRegex:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF1:test(err.stack)).toEqual(true)
		jestExpect(stacktraceRegexF2:test(err.stack)).toEqual(false)
	end)
end)

describe("stack", function()
	local lineNumber = ""
	local function createError()
		lineNumber = tostring(debug.info(1, "l") :: number + 1)
		local err = Error.new("initial message")
		return err
	end

	-- FIXME
	it.skip("should include new message if stacktrace NOT accessed before", function()
		local res = createError()
		res.message = "new message"
		assert(typeof(res.stack) == "string", "stack should be defined")
		local expectedMessage = "Error: new message\n"
		local expectedStack = (
			"LoadedCode%.LuauPolyfillTestModel%.Packages%._Workspace%.LuauPolyfill%-%d%.%d%.%d%.LuauPolyfill%.Error%.__tests__%.Error%.spec:"
			.. lineNumber
			.. " function createError"
		)
		local expectedMessageIndex = 1
		local expectedStackIndex = string.len(expectedMessage) + 1
		local msgIndex = res.stack:find(expectedMessage)
		local stackIndex = res.stack:find(expectedStack, 1)
		jestExpect(msgIndex).toBe(expectedMessageIndex)
		jestExpect(stackIndex).toBe(expectedStackIndex)
	end)

	it("should include initial message if stacktrace IS accessed before", function()
		local res = createError()
		local _tmp = res.stack
		res.message = "new message"
		assert(typeof(res.stack) == "string", "stack should be defined")
		local expectedMessage = "Error: initial message\n"
		local expectedStack = (
			"LoadedCode%.LuauPolyfillTestModel%.Packages%._Workspace%.LuauPolyfill%-%d%.%d%.%d%.LuauPolyfill%.Error%.__tests__%.Error%.spec:"
			.. lineNumber
			.. " function createError"
		)
		local expectedMessageIndex = 1
		local expectedStackIndex = string.len(expectedMessage) + 1
		local msgIndex = res.stack:find(expectedMessage)
		local stackIndex = res.stack:find(expectedStack, 1)
		jestExpect(msgIndex).toBe(expectedMessageIndex)
		jestExpect(stackIndex).toBe(expectedStackIndex)
	end)
end)

describe("name", function()
	local lineNumber = ""
	local function createError()
		lineNumber = tostring(debug.info(1, "l") :: number + 1)
		local err = Error.new("initial message")
		return err
	end

	-- FIXME
	it.skip("should include new name if stacktrace NOT accessed before", function()
		local res = createError()
		res.name = "MyCustomError"
		assert(typeof(res.stack) == "string", "stack should be defined")
		local expectedMessage = "MyCustomError: initial message\n"
		local expectedStack = (
			"LoadedCode%.LuauPolyfillTestModel%.Packages%._Workspace%.LuauPolyfill%-%d%.%d%.%d%.LuauPolyfill%.Error%.__tests__%.Error%.spec:"
			.. lineNumber
			.. " function createError"
		)
		local expectedMessageIndex = 1
		local expectedStackIndex = string.len(expectedMessage) + 1
		local msgIndex = res.stack:find(expectedMessage)
		local stackIndex = res.stack:find(expectedStack, 1)
		jestExpect(msgIndex).toBe(expectedMessageIndex)
		jestExpect(stackIndex).toBe(expectedStackIndex)
	end)

	it("should include initial name if stacktrace IS accessed before", function()
		local res = createError()
		local _tmp = res.stack
		res.name = "MyCustomError"
		assert(typeof(res.stack) == "string", "stack should be defined")
		local expectedMessage = "Error: initial message\n"
		local expectedStack = (
			"LoadedCode%.LuauPolyfillTestModel%.Packages%._Workspace%.LuauPolyfill%-%d%.%d%.%d%.LuauPolyfill%.Error%.__tests__%.Error%.spec:"
			.. lineNumber
			.. " function createError"
		)
		local expectedMessageIndex = 1
		local expectedStackIndex = string.len(expectedMessage) + 1
		local msgIndex = res.stack:find(expectedMessage)
		local stackIndex = res.stack:find(expectedStack, 1)
		jestExpect(msgIndex).toBe(expectedMessageIndex)
		jestExpect(stackIndex).toBe(expectedStackIndex)
	end)
end)

describe("__recalculateStacktrace", function()
	local lineNumber = ""
	local function createError()
		lineNumber = tostring(debug.info(1, "l") :: number + 1)
		local err = Error.new("initial message")
		return err
	end

	it("should include new message if __recalculateStacktrace is called", function()
		local res = createError()
		res.message = "new message"
		Error.__recalculateStacktrace(res)
		assert(typeof(res.stack) == "string", "stack should be defined")
		local expectedMessage = "Error: new message\n"
		local expectedStack = (
			"LoadedCode%.LuauPolyfillTestModel%.Packages%._Workspace%.LuauPolyfill%-%d%.%d%.%d%.LuauPolyfill%.Error%.__tests__%.Error%.spec:"
			.. lineNumber
			.. " function createError"
		)
		local expectedMessageIndex = 1
		local expectedStackIndex = string.len(expectedMessage) + 1
		local msgIndex = res.stack:find(expectedMessage)
		local stackIndex = res.stack:find(expectedStack, 1)
		jestExpect(msgIndex).toBe(expectedMessageIndex)
		jestExpect(stackIndex).toBe(expectedStackIndex)
	end)

	it("should include initial message if __recalculateStacktrace is NOT called", function()
		local res = createError()
		res.message = "new message"
		assert(typeof(res.stack) == "string", "stack should be defined")
		local expectedMessage = "Error: initial message\n"
		local expectedStack = (
			"LoadedCode%.LuauPolyfillTestModel%.Packages%._Workspace%.LuauPolyfill%-%d%.%d%.%d%.LuauPolyfill%.Error%.__tests__%.Error%.spec:"
			.. lineNumber
			.. " function createError"
		)
		local expectedMessageIndex = 1
		local expectedStackIndex = string.len(expectedMessage) + 1
		local msgIndex = res.stack:find(expectedMessage, 1, true)
		local stackIndex = res.stack:find(expectedStack, 1)
		jestExpect(msgIndex).toBe(expectedMessageIndex)
		jestExpect(stackIndex).toBe(expectedStackIndex)
	end)
end)

describe("extend Error", function()
	type CustomError = Error & {}

	type CustomError_statics = { new: (message: any) -> CustomError }
	local CustomError
	CustomError = (setmetatable({}, {
		__index = Error,
	}) :: any) :: CustomError & CustomError_statics;
	(CustomError :: any).__index = CustomError
	function CustomError.new(message): CustomError
		local self = setmetatable(Error.new(message), CustomError)
		self.name = "CustomError"
		return (self :: any) :: CustomError
	end

	it("should have stack accessible from a subclass instance (using extends function)", function()
		local customError = MyError.new("some message")

		jestExpect(customError.stack).toBeDefined()
		jestExpect(instanceof(customError, MyError)).toBe(true)
		jestExpect(instanceof(customError, Error)).toBe(true)
	end)

	it("should have stack accessible from a subclass instance (manual)", function()
		local customError = CustomError.new("some message")

		jestExpect(customError.stack).toBeDefined()
		jestExpect(instanceof(customError, CustomError)).toBe(true)
		jestExpect(instanceof(customError, Error)).toBe(true)
	end)
end)
