local Timers = require(script.Timers)
local Array = require(script.Array)
local mapModule = require(script.Map)
local Set = require(script.Set)
local WeakMap = require(script.WeakMap)

export type Array<T> = Array.Array<T>
export type Map<T, V> = mapModule.Map<T, V>
export type Set<T> = Set.Set<T>
export type WeakMap<T, V> = WeakMap.WeakMap<T, V>

return {
	Array = Array,
	Boolean = require(script.Boolean),
	console = require(script.console),
	Error = require(script.Error),
	extends = require(script.extends),
	instanceof = require(script.instanceof),
	Math = require(script.Math),
	Number = require(script.Number),
	Object = require(script.Object),
	Map = mapModule.Map,
	coerceToMap = mapModule.coerceToMap,
	coerceToTable = mapModule.coerceToTable,
	Set = Set,
	WeakMap = WeakMap,
	String = require(script.String),
	Symbol = require(script.Symbol),
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
	util = require(script.util),
}