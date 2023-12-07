local Map = require("./Map")
local Object = require("../Object")
local instanceOf = require("@pkg/@jsdotlua/instance-of")
local types = require("@pkg/@jsdotlua/es7-types")

type Map<K, V> = types.Map<K, V>
type Table<K, V> = types.Table<K, V>

local function coerceToMap(mapLike: Map<any, any> | Table<any, any>): Map<any, any>
	return instanceOf(mapLike, Map) and mapLike :: Map<any, any> -- ROBLOX: order is preserved
		or Map.new(Object.entries(mapLike)) -- ROBLOX: order is not preserved
end

return coerceToMap
