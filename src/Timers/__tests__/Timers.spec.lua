return function()
	local Timers = script.Parent.Parent
	local makeTimerImpl = require(Timers.makeTimerImpl)
	local makeIntervalImpl = require(Timers.makeIntervalImpl)
	local LuauPolyfill = Timers.Parent

	local Packages = LuauPolyfill.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest
	local Promise = require(Packages.Dev.Promise)

	local Timeout
	local Interval
	local mockTime: number
	local timeouts

	type Interval = makeIntervalImpl.Interval

	describe("with fake delay", function()
		local function advanceTime(amount: number)
			-- Account for milliseconds to seconds conversion here, since Timeout
			-- will make the same adjustment
			mockTime += amount / 1000
			for _, update in pairs(timeouts) do
				update(mockTime)
			end
		end

		local function mockDelay(delayTime: number, callback)
			local targetTime = mockTime + delayTime
			timeouts[callback] = function(currentTime)
				if currentTime >= targetTime then
					callback()
					timeouts[callback] = nil
				end
			end
		end

		beforeEach(function()
			mockTime = 0
			timeouts = {}
			Timeout = makeTimerImpl(mockDelay)
			Interval = makeIntervalImpl(mockDelay)
		end)

		describe("Delay override logic", function()
			it("should not run delayed callbacks immediately", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 50)

				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)

			it("should run callbacks after timers have been advanced sufficiently", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				advanceTime(50)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
				advanceTime(50)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
			end)
		end)

		describe("Timeout", function()
			it("should run exactly once", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
				advanceTime(1)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
			end)

			it("should be called with the given args", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 100, "hello", "world")

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
				jestExpect(callbackSpy).toHaveBeenCalledWith("hello", "world")
			end)

			it("should not run if cancelled before it is scheduled to run", function()
				local callbackSpy = jest.fn()
				local task = Timeout.setTimeout(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				Timeout.clearTimeout(task)
				advanceTime(100)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)

			it("should not throw if clearTimeout is given nil", function()
				jestExpect(function()
					-- types don't permit this abuse, so cast away safety
					(Timeout.clearTimeout :: any)(nil)
				end).never.toThrow()
			end)
		end)

		describe("Interval", function()
			local id: Interval?

			afterEach(function()
				if id then
					Interval.clearInterval(id)
				end
				id = nil
			end)

			it("should not run immediately", function()
				local callbackSpy = jest.fn()
				id = Interval.setInterval(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)

			it("should run once every delay", function()
				local callbackSpy = jest.fn()
				Interval.setInterval(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(2)
				advanceTime(1)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(2)

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(3)
			end)

			it("should be called with the given args", function()
				local callbackSpy = jest.fn()
				Interval.setInterval(callbackSpy, 100, "hello", "world")

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
				jestExpect(callbackSpy).toHaveBeenCalledWith("hello", "world")
			end)

			it("should not run if cancelled before it is scheduled to run", function()
				local callbackSpy = jest.fn()
				id = Interval.setInterval(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				Interval.clearInterval(id :: Interval)
				advanceTime(100)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)
		end)
	end)

	describe("with real delay", function()
		local function advanceTime(ms: number): ()
			-- Account for milliseconds to seconds conversion here, since Timeout
			-- will make the same adjustment
			Promise.delay(ms / 1000):expect()
		end
		beforeEach(function()
			Timeout = makeTimerImpl(task.delay)
			Interval = makeIntervalImpl(task.delay)
		end)

		describe("Timeout", function()
			it("should not run delayed callbacks immediately", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 50)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)

			it("should run exactly once", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
				advanceTime(1)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
			end)

			it("should be called with the given args", function()
				local callbackSpy = jest.fn()
				Timeout.setTimeout(callbackSpy, 100, "hello", "world")

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
				jestExpect(callbackSpy).toHaveBeenCalledWith("hello", "world")
			end)

			it("should not run if cancelled before it is scheduled to run", function()
				local callbackSpy = jest.fn()
				local task = Timeout.setTimeout(callbackSpy, 50)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				Timeout.clearTimeout(task)
				advanceTime(100)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)
		end)

		describe("Interval", function()
			local id: Interval?

			afterEach(function()
				if id then
					Interval.clearInterval(id)
				end
				id = nil
			end)

			it("should not run delayed callbacks immediately", function()
				local callbackSpy = jest.fn()
				id = Interval.setInterval(callbackSpy, 50)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)

			it("should run once every delay", function()
				local callbackSpy = jest.fn()
				id = Interval.setInterval(callbackSpy, 100)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(2)
				advanceTime(1)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(2)

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(3)
			end)

			it("should be called with the given args", function()
				local callbackSpy = jest.fn()
				id = Interval.setInterval(callbackSpy, 100, "hello", "world")

				advanceTime(100)
				jestExpect(callbackSpy).toHaveBeenCalledTimes(1)
				jestExpect(callbackSpy).toHaveBeenCalledWith("hello", "world")
			end)

			it("should not run if cancelled before it is scheduled to run", function()
				local callbackSpy = jest.fn()
				id = Interval.setInterval(callbackSpy, 50)

				jestExpect(callbackSpy).never.toHaveBeenCalled()

				Interval.clearInterval(id :: Interval)
				advanceTime(100)
				jestExpect(callbackSpy).never.toHaveBeenCalled()
			end)

			it("should not throw if clearInterval is given nil", function()
				jestExpect(function()
					-- types don't permit this abuse, so cast away safety
					(Interval.clearInterval :: any)(nil)
				end).never.toThrow()
			end)
		end)
	end)
end
