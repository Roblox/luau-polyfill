--!strict
local Packages = script.Parent.Parent
local ES7Types = require(Packages.ES7Types)

export type Array<T> = ES7Types.Array<T>

return {
	concat = require(script.concat),
	every = require(script.every),
	filter = require(script.filter),
	find = require(script.find),
	findIndex = require(script.findIndex),
	flat = require(script.flat),
	flatMap = require(script.flatMap),
	forEach = require(script.forEach),
	from = require(script.from),
	includes = require(script.includes),
	indexOf = require(script.indexOf),
	isArray = require(script.isArray),
	join = require(script.join),
	map = require(script.map),
	reduce = require(script.reduce),
	reverse = require(script.reverse),
	shift = require(script.shift),
	slice = require(script.slice),
	some = require(script.some),
	sort = require(script.sort),
	splice = require(script.splice),
	unshift = require(script.unshift),
}