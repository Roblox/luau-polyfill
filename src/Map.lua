--!strict
local LuauPolyfill = script.Parent
local types = require(LuauPolyfill.types)

local Array = require(LuauPolyfill.Array)
local Object = require(LuauPolyfill.Object)
local instanceOf = require(LuauPolyfill.instanceof)
type Object = types.Object
type Array<T> = types.Array<T>
type Table<T, V> = types.Table<T, V>
type Tuple<T, V> = types.Tuple<T, V>
type mapCallbackFn<K, V> = types.mapCallbackFn<K, V>
type mapCallbackFnWithThisArg<K, V> = types.mapCallbackFnWithThisArg<K, V>
type Map<K, V> = types.Map<K, V>

local Map = {}

function Map.new<K, V>(iterable: Array<Array<any>>?): Map<K, V>
	local array
	local map = {}
	if iterable ~= nil then
		local arrayFromIterable
		local iterableType = typeof(iterable)
		if iterableType == "table" then
			if #iterable > 0 and typeof(iterable[1]) ~= "table" then
				error("cannot create Map from {K, V} form, it must be { {K, V}... }")
			end

			arrayFromIterable = Array.from(iterable)
		else
			error(("cannot create array from value of type `%s`"):format(iterableType))
		end

		array = table.create(#arrayFromIterable)
		for _, entry in ipairs(arrayFromIterable) do
			local key = entry[1]
			if _G.__DEV__ then
				if key == nil then
					error("cannot create Map from a table that isn't an array.")
				end
			end
			local val = entry[2]
			-- only add to array if new
			if map[key] == nil then
				table.insert(array, key)
			end
			-- always assign
			map[key] = val
		end
	else
		array = {}
	end

	return (setmetatable({
		size = #array,
		_map = map,
		_array = array,
	}, Map) :: any) :: Map<K, V>
end

function Map:set<K, V>(key: K, value: V): Map<K, V>
	-- preserve initial insertion order
	if self._map[key] == nil then
		-- Luau FIXME: analyze should know self is Map<K, V> which includes size as a number
		self.size = self.size :: number + 1
		table.insert(self._array, key)
	end
	-- always update value
	self._map[key] = value
	return self
end

function Map:get(key)
	return self._map[key]
end

function Map:clear()
	local table_: any = table
	self.size = 0
	table_.clear(self._map)
	table_.clear(self._array)
end

function Map:delete(key): boolean
	if self._map[key] == nil then
		return false
	end
	-- Luau FIXME: analyze should know self is Map<K, V> which includes size as a number
	self.size = self.size :: number - 1
	self._map[key] = nil
	local index = table.find(self._array, key)
	if index then
		table.remove(self._array, index)
	end
	return true
end

-- Implements Javascript's `Map.prototype.forEach` as defined below
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map/forEach
function Map:forEach<K, V>(callback: mapCallbackFn<K, V> | mapCallbackFnWithThisArg<K, V>, thisArg: Object?): ()
	if typeof(callback) ~= "function" then
		error("callback is not a function")
	end

	return Array.forEach(self._array, function(key: K)
		local value: V = self._map[key] :: V

		if thisArg ~= nil then
			(callback :: mapCallbackFnWithThisArg<K, V>)(thisArg, value, key, self)
		else
			(callback :: mapCallbackFn<K, V>)(value, key, self)
		end
	end)
end

function Map:has(key): boolean
	return self._map[key] ~= nil
end

function Map:keys()
	return self._array
end

function Map:values()
	return Array.map(self._array, function(key)
		return self._map[key]
	end)
end

function Map:entries()
	return Array.map(self._array, function(key)
		return { key, self._map[key] }
	end)
end

function Map:ipairs()
	return ipairs(self:entries())
end

function Map.__index(self, key)
	local mapProp = rawget(Map, key)
	if mapProp ~= nil then
		return mapProp
	end

	return Map.get(self, key)
end

function Map.__newindex(table_, key, value)
	table_:set(key, value)
end

local function coerceToMap(mapLike: Map<any, any> | Table<any, any>): Map<any, any>
	return instanceOf(mapLike, Map) and mapLike :: Map<any, any> -- ROBLOX: order is preservered
		or Map.new(Object.entries(mapLike)) -- ROBLOX: order is not preserved
end

local function coerceToTable(mapLike: Map<any, any> | Table<any, any>): Table<any, any>
	if not instanceOf(mapLike, Map) then
		return mapLike
	end

	-- create table from map
	return Array.reduce(mapLike:entries(), function(tbl, entry)
		tbl[entry[1]] = entry[2]
		return tbl
	end, {})
end

return {
	Map = Map,
	coerceToMap = coerceToMap,
	coerceToTable = coerceToTable,
}
