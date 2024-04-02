local ES7Types = require("@pkg/@jsdotlua/es7-types")

export type Array<T> = ES7Types.Array<T>

return {
	concat = require("./concat"),
	every = require("./every"),
	filter = require("./filter"),
	find = require("./find"),
	findIndex = require("./findIndex"),
	flat = require("./flat"),
	flatMap = require("./flatMap"),
	forEach = require("./forEach"),
	from = require("./from"),
	includes = require("./includes"),
	indexOf = require("./indexOf"),
	isArray = require("./isArray"),
	join = require("./join"),
	map = require("./map"),
	reduce = require("./reduce"),
	reverse = require("./reverse"),
	shift = require("./shift"),
	slice = require("./slice"),
	some = require("./some"),
	sort = require("./sort"),
	splice = require("./splice"),
	unshift = require("./unshift"),
}
