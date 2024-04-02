local Array = require("./Array")
local Map = require("./Map")
local Object = require("./Object")
local Set = require("./Set")
local WeakMap = require("./WeakMap")
local inspect = require("./inspect")

local types = require("@pkg/@jsdotlua/es7-types")

export type Array<T> = types.Array<T>
export type Map<T, V> = types.Map<T, V>
export type Object = types.Object
export type Set<T> = types.Set<T>
export type WeakMap<T, V> = types.WeakMap<T, V>

return {
	Array = Array,
	Object = Object,
	Map = Map.Map,
	coerceToMap = Map.coerceToMap,
	coerceToTable = Map.coerceToTable,
	Set = Set,
	WeakMap = WeakMap,
	inspect = inspect,
}
