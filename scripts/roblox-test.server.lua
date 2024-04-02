local ReplicatedStorage = game:GetService('ReplicatedStorage')

local jest = require('@pkg/@jsdotlua/jest')

local jsdotlua = ReplicatedStorage:FindFirstChild('node_modules'):FindFirstChild("@jsdotlua")

local jestRoots = {
    jsdotlua:FindFirstChild("boolean"),
    jsdotlua:FindFirstChild("collections"),
    jsdotlua:FindFirstChild("console"),
    jsdotlua:FindFirstChild("instance-of"),
    jsdotlua:FindFirstChild("luau-polyfill"),
    jsdotlua:FindFirstChild("math"),
    jsdotlua:FindFirstChild("number"),
    jsdotlua:FindFirstChild("string"),
    jsdotlua:FindFirstChild("timers"),
}

local success, result = jest.runCLI(ReplicatedStorage, {}, jestRoots):await()

if not success then
    error(result)
end

task.wait(0.5)
