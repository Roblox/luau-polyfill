local function slice(str: string, startIndexStr: string | number, lastIndexStr: (string | number)?): string
	local strLen = utf8.len(str)
	assert(type(startIndexStr) == "number", "startIndexStr should be a number")

	if tonumber(startIndexStr) + strLen < 0 then
		-- then |start index| is greater than string length
		startIndexStr = 1
	end

	if startIndexStr > strLen then
		return ""
	end

	-- if no last index length set, go to str length + 1
	if lastIndexStr == nil then
		lastIndexStr = strLen + 1
	end
	assert(type(lastIndexStr) == "number", "lastIndexStr should be a number")

	if lastIndexStr > strLen then
		lastIndexStr = strLen + 1
	end

	local startIndexByte = utf8.offset(str, startIndexStr)
	-- get char length of charset retunred at offset
	local lastIndexByte = utf8.offset(str, lastIndexStr) - 1

	return string.sub(str, startIndexByte, lastIndexByte)
end

return slice
