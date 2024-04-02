return {
	assign = require("./assign"),
	entries = require("./entries"),
	freeze = require("./freeze"),
	is = require("./is"),
	isFrozen = require("./isFrozen"),
	keys = require("./keys"),
	preventExtensions = require("./preventExtensions"),
	seal = require("./seal"),
	values = require("./values"),
	-- Special marker type used in conjunction with `assign` to remove values
	-- from tables, since nil cannot be stored in a table
	None = require("./None"),
}
