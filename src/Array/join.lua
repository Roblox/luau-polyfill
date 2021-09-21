type Array<T> = { [number]: T }

local function join(arr: Array<string>, separator: string?): string
	return table.concat(arr, separator or ",")
end

return join
