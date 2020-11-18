return {
	assign = require(script.assign),
	freeze = require(script.freeze),
	keys = require(script.keys),
	seal = require(script.seal),
	preventExtensions = require(script.preventExtensions),
	-- Special marker type used in conjunction with `assign` to remove values
	-- from tables, since nil cannot be stored in a table
	None = require(script.None),
}