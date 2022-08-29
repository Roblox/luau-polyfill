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
local ProcessService = game:GetService("ProcessService")
local Root = script.Parent.LuauPolyfillTestModel

local Packages = Root.Packages
-- Load JestRoblox source into Packages folder so it's next to Roact as expected
local TestEZ = require(Packages._Workspace:FindFirstChild("TestEZ", true))

-- Run all tests, collect results, and report to stdout.
local result = TestEZ.TestBootstrap:run({ Packages._Workspace }, TestEZ.Reporters.TextReporterQuiet)

if result.failureCount == 0 and #result.errors == 0 then
	ProcessService:ExitAsync(0)
else
	ProcessService:ExitAsync(1)
end
