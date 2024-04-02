local trimStart = require("./trimStart")
local trimEnd = require("./trimEnd")

return function(source: string): string
	return trimStart(trimEnd(source))
end
