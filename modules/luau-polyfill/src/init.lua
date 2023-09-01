--!strict
local Packages = script.Parent

local Boolean = require(Packages.Boolean)
local Collections = require(Packages.Collections)
local Console = require(Packages.Console)
local Math = require(Packages.Math)
local Number = require(Packages.Number)
local String = require(Packages.String)
local Symbol = require(Packages.Symbol)
local Timers = require(Packages.Timers)
local types = require(Packages.ES7Types)

local AssertionError = require(script.AssertionError)
local Error = require(script.Error)
local PromiseModule = require(script.Promise)
local extends = require(script.extends)
local instanceof = require(Packages.InstanceOf)

export type Array<T> = types.Array<T>
export type AssertionError = AssertionError.AssertionError
export type Error = Error.Error
export type Map<T, V> = types.Map<T, V>
export type Object = types.Object

export type PromiseLike<T> = PromiseModule.PromiseLike<T>
export type Promise<T> = PromiseModule.Promise<T>

export type Set<T> = types.Set<T>
export type Symbol = Symbol.Symbol
export type Timeout = Timers.Timeout
export type Interval = Timers.Interval
export type WeakMap<T, V> = Collections.WeakMap<T, V>

return {
	Array = Collections.Array,
	AssertionError = AssertionError,
	Boolean = Boolean,
	console = Console,
	Error = Error,
	extends = extends,
	instanceof = instanceof,
	Math = Math,
	Number = Number,
	Object = Collections.Object,
	Map = Collections.Map,
	coerceToMap = Collections.coerceToMap,
	coerceToTable = Collections.coerceToTable,
	Set = Collections.Set,
	WeakMap = Collections.WeakMap,
	String = String,
	Symbol = Symbol,
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
	setInterval = Timers.setInterval,
	clearInterval = Timers.clearInterval,
	util = {
		inspect = Collections.inspect,
	},
}
