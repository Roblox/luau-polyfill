--!nocheck
local Error = {}

local DEFAULT_NAME = "Error"

function Error.new(message)
	return {
		name = DEFAULT_NAME,
		message = message,
	}
end

return setmetatable(Error, {

	__call = function(_, ...)
		return Error.new(...)
	end,
	__tostring = function(self)
		if self.name ~= nil then
			if self.message ~= nil then
				return string.format("%s: %s", tostring(self.name), tostring(self.message))
			end
			return tostring(self.name)
		end
		return tostring(DEFAULT_NAME)
	end
})