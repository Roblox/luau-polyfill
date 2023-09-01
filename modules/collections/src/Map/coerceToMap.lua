local MapModule = script.Parent
local Collections = MapModule.Parent
local Packages = Collections.Parent

local Map = require(MapModule.Map)
local Object = require(Collections.Object)
local instanceOf = require(Packages.InstanceOf)
local types = require(Packages.ES7Types)

type Map<K, V> = types.Map<K, V>
type Table<K, V> = types.Table<K, V>

local function coerceToMap(mapLike: Map<any, any> | Table<any, any>): Map<any, any>
	return instanceOf(mapLike, Map) and mapLike :: Map<any, any> -- ROBLOX: order is preserved
		or Map.new(Object.entries(mapLike)) -- ROBLOX: order is not preserved
end

return coerceToMap
