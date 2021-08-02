local Timers = require(script.Timers)
local Array = require(script.Array)
local Set = require(script.Set)

export type Array<T> = Array.Array<T>
export type Set<T> = Set.Set<T>

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
	Set = Set,
	String = require(script.String),
	Symbol = require(script.Symbol),
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
	util = require(script.util),
}