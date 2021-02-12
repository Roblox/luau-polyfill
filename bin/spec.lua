local ProcessService = game:GetService("ProcessService")
local Root = script.Parent.LuauPolyfillTestModel

-- Load RoactNavigation source into Packages folder so it's next to Roact as expected
local TestEZ = require(Root.Packages.Dev.TestEZ)

-- Run all tests, collect results, and report to stdout.
local result = TestEZ.TestBootstrap:run(
	{ Root.LuauPolyfill },
	TestEZ.Reporters.TextReporter
)

if result.failureCount == 0 then
	ProcessService:ExitAsync(0)
else
	ProcessService:ExitAsync(1)
end
