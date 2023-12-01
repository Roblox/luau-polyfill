local Map = require("./Map")
local instanceOf = require("@pkg/@jsdotlua/instance-of")
local arrayReduce = require("../Array/reduce")
local types = require("@pkg/@jsdotlua/es7-types")

type Map<K, V> = types.Map<K, V>
type Table<K, V> = types.Table<K, V>

local function coerceToTable(mapLike: Map<any, any> | Table<any, any>): Table<any, any>
	if not instanceOf(mapLike, Map) then
		return mapLike :: Table<any, any>
	end

	-- create table from map
	return arrayReduce(mapLike:entries(), function(tbl, entry)
		tbl[entry[1]] = entry[2]
		return tbl
	end, {})
end

return coerceToTable
