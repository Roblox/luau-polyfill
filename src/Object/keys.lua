return function(t)
	local keys = {}
	for key in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end
