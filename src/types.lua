--!strict
export type Object = { [string]: any }
export type Array<T> = { [number]: T }
export type Function = (...any) -> ...any
export type Table<T, V> = { [T]: V }
export type Tuple<T, V> = Array<T | V>
export type mapCallbackFn<K, V> = (element: V, key: K, map: Map<K, V>) -> ()
export type mapCallbackFnWithThisArg<K, V> = (thisArg: Object, value: V, key: K, map: Map<K, V>) -> ()

export type Map<K, V> = {
	size: number,
	-- method definitions
	set: (self: Map<K, V>, K, V) -> Map<K, V>,
	get: (self: Map<K, V>, K) -> V | nil,
	clear: (self: Map<K, V>) -> (),
	delete: (self: Map<K, V>, K) -> boolean,
	forEach: (self: Map<K, V>, callback: mapCallbackFn<K, V> | mapCallbackFnWithThisArg<K, V>, thisArg: Object?) -> (),
	has: (self: Map<K, V>, K) -> boolean,
	keys: (self: Map<K, V>) -> Array<K>,
	values: (self: Map<K, V>) -> Array<V>,
	entries: (self: Map<K, V>) -> Array<Tuple<K, V>>,
	ipairs: (self: Map<K, V>) -> any,
	[K]: V,
	_map: { [K]: V },
	_array: { [number]: K },
}

export type setCallbackFn<T> = (value: T, key: T, set: Set<T>) -> ()
export type setCallbackFnWithThisArg<T> = (thisArg: Object, value: T, key: T, set: Set<T>) -> ()

export type Set<T> = {
	size: number,
	-- method definitions
	add: (self: Set<T>, T) -> Set<T>,
	clear: (self: Set<T>) -> (),
	delete: (self: Set<T>, T) -> boolean,
	forEach: (self: Set<T>, callback: setCallbackFn<T> | setCallbackFnWithThisArg<T>, thisArg: Object?) -> (),
	has: (self: Set<T>, T) -> boolean,
	ipairs: (self: Set<T>) -> any,
}

return {}
