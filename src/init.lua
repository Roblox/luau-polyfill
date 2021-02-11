local Timers = require(script.Timers)

return {
	Array = require(script.Array),
	Boolean = require(script.Boolean),
	console = require(script.console),
	Error = require(script.Error),
	instanceof = require(script.instanceof),
	Math = require(script.Math),
	Number = require(script.Number),
	Object = require(script.Object),
	RegExp = require(script.RegExp),
	String = require(script.String),
	Symbol = require(script.Symbol),
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
}