--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
--!strict
local Array = require(script.Array)
local AssertionError = require(script.AssertionError)
local Error = require(script.Error)
local Object = require(script.Object)
local PromiseModule = require(script.Promise)
local Set = require(script.Set)
local Symbol = require(script.Symbol)
local Timers = require(script.Timers)
local WeakMap = require(script.WeakMap)
local Map = require(script.Map)
local coerceToMap = require(script.Map.coerceToMap)
local coerceToTable = require(script.Map.coerceToTable)
local types = require(script.types)

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
export type WeakMap<T, V> = WeakMap.WeakMap<T, V>

return {
	Array = Array,
	AssertionError = AssertionError,
	Boolean = require(script.Boolean),
	console = require(script.console),
	Error = Error,
	extends = require(script.extends),
	instanceof = require(script.instanceof),
	Math = require(script.Math),
	Number = require(script.Number),
	Object = Object,
	Map = Map,
	coerceToMap = coerceToMap,
	coerceToTable = coerceToTable,
	Set = Set,
	WeakMap = WeakMap,
	String = require(script.String),
	Symbol = Symbol,
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
	setInterval = Timers.setInterval,
	clearInterval = Timers.clearInterval,
	util = require(script.util),
}
