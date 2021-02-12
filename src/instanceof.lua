--!nonstrict
-- polyfill for https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/instanceof
return function(tbl, class)
	if typeof(tbl) ~= "table" then
		return false
	end

	if typeof(class) == "function" then
		print("Warning: received a function not a table as the class for inheritance check")
	end

	while typeof(tbl) == "table" and tbl ~= nil do
		tbl = getmetatable(tbl)
		if typeof(tbl) == "table" and tbl ~= nil then
			tbl = tbl.__index

			if tbl == class then
				return true
			end
		end
	end
	return false
end