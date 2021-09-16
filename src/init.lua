local Array = require(script.Array)
local Error = require(script.Error)
local mapModule = require(script.Map)
local Object = require(script.Object)
local Set = require(script.Set)
local Timers = require(script.Timers)
local WeakMap = require(script.WeakMap)

export type Array<T> = Array.Array<T>
export type Error = Error.Error
export type Map<T, V> = mapModule.Map<T, V>
export type Object = Object.Object

-- this maps onto community promise libraries which won't support Luau, so we inline
export type PromiseLike<T> = {
	andThen: (
		((T) -> T)? | (PromiseLike<T>)?, -- resolve
		((any) -> () | PromiseLike<T>)? -- reject
	) -> PromiseLike<T>,
}

export type Promise<T> = {
	andThen: ((
		((T) -> T | PromiseLike<T>)?, -- resolve
		((any) -> () | PromiseLike<nil>)? -- reject
	) -> Promise<T>)?,

	catch: ((((any) -> () | PromiseLike<nil>)) -> Promise<T>)?,

	onCancel: ((() -> ()?) -> boolean)?,
}

export type Set<T> = Set.Set<T>
export type WeakMap<T, V> = WeakMap.WeakMap<T, V>

return {
	Array = Array,
	Boolean = require(script.Boolean),
	console = require(script.console),
	Error = Error,
	extends = require(script.extends),
	instanceof = require(script.instanceof),
	Math = require(script.Math),
	Number = require(script.Number),
	Object = Object,
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
