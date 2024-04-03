-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isSafeInteger
local isInteger = require("./isInteger")
local MAX_SAFE_INTEGER = require("./MAX_SAFE_INTEGER")

return function(value)
	return isInteger(value) and math.abs(value) <= MAX_SAFE_INTEGER
end
