local Timers = require(script.Timers)

return {
	Array = require(script.Array),
	console = require(script.console),
	Error = require(script.Error),
	Math = require(script.Math),
	Object = require(script.Object),
	String = require(script.String),
	setTimeout = Timers.setTimeout,
	clearTimeout = Timers.clearTimeout,
}