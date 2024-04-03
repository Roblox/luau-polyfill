local ES7Types = require("@pkg/@jsdotlua/es7-types")

local Map = require("./Map")
local coerceToMap = require("./coerceToMap")
local coerceToTable = require("./coerceToTable")

export type Map<K, V> = ES7Types.Map<K, V>

return {
	Map = Map,
	coerceToMap = coerceToMap,
	coerceToTable = coerceToTable,
}
