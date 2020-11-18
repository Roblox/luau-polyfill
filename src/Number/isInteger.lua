return function(value)
	return type(value) == "number" and value ~= 1/0 and value == math.floor(value)
end
