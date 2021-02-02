--!nocheck
local Error = {}

local DEFAULT_NAME = "Error"

function Error.new(_, message)
	return setmetatable({
		name = DEFAULT_NAME,
		message = message,
	}, {
		__tostring = function(self)
			return string.format("%s: %s", tostring(self.name), tostring(self.message))
		end
	})
end

function Error.extend(parentError, childErrorName)
	local ChildError = {}

	ChildError.__index = parentError
	ChildError.__tostring = function(self)
		return string.format("%s: %s", tostring(self.name), tostring(self.message))
	end

	function ChildError.new(_, message)
		return setmetatable({
			name = childErrorName,
			message = message,
		}, ChildError)
	end

	setmetatable(ChildError, {
		__call = ChildError.new,
		__index = parentError,
		__tostring = function(self)
			return tostring(childErrorName)
		end
	})

	return ChildError
end

return setmetatable(Error, {
	__call = Error.new,
	__tostring = function(self)
		return tostring(DEFAULT_NAME)
	end
})