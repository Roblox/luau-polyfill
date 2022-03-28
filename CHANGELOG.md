# LuauPolyfills Changelog

## Unreleased

### Added Polyfills
* implement `setInterval` and `clearInterval`

## 0.3.1

### Changes
* `inspect` now accepts an optional options table with a depth option that allows inspecting values deeper then the default of two.
* `Array.concat` will now accept a non-array as the first parameter, matching the `Array.prototype.concat` behavior from JavaScript, and relied upon by React 17's `useImperativeHandle` tests.
* `Array.sort` will now accept `Object.None` (our equivalent of JS' `undefined`) for the comparator and use the default sort.
* the default sort in `Array.sort` now uses a more durable implementation, taking into account the `type()` *and* `tostring()`.

## 0.3.0

### Breaking Changes
* strongly type `Set.new`, which allows Luau analysis to catch many new classes of issues. If `Set.new` is used without arguments, the `T` in the `Set<T>` return type cannot be inferred and may result in new analyze warnings. You will now need to add a typecheck operator: `local interactions = Set.new() :: Set<string>`
* strongly type `Map.new`, which allows Luau analysis to catch many new classes of issues. If `Map.new` is used without arguments, the `K` and `V` in the `Map<K, V>` return type cannot be inferred and may result in new analyze warnings. You will now need to add a typecheck operator: `local myMap = Map.new() :: Map<string, MyType>`
* `Array.concat` was incorrectly modeled in terms of functionality and types. The first argument now *must* be an `Array<>`, it will type check the arguments, and retain the appropriate types in the return value.


### Changes
* `Object.freeze` now uses `table.freeze`
* add `isFrozen` method to `Object`
* Strict luau type mode enabled on almost all polyfill files and tests. This may highlight latent type issues in code that consumes the polyfills.
* `setTimeout` now uses `task.delay` as the default implementation, increasing timer resolution from 30hz to 60hz.
* `toExponential` now returns "nan" when given invalid values, more closely matching MDN documentation and in-browser tests.


### Added Polyfills
* add `forEach` method to `Set`
* add `forEach` method to `Map`
* add `isFrozen` method to `Object`
* add `debug` method to `console`

### Fixes
* `Array.forEach` will no longer incorrectly call the callback when the array length changes. The callback also is now more correctly typed.
* the `Object` type exported no longer uses nil-able values, which works around some Luau inference issues, and better matches the typical intention of using it.
* `Array.from` will now respect the `thisArg` argument when it is supplied.
* `Array.slice` and `Array.filter` will no longer erase the type of the `Array<>` being operated on.
* `Object.assign` will now pass through more original information on source and target types. Uses where the target is an empty table `Object.assign({}, myTable, otherTable)` may require an explicit annotation on assignment to a local variable.

## 0.2.6
* add `has` method to `WeakMap`
* add `expect` method to `Promise`
* add `self` param to `Promise`'s methods

## 0.2.5

### Fixes
* Fix for `Array.sort` to make comparator argument optional
* Tighten callback and predicate argument types for many Array methods: `every`, `filter`, `find`, `foreach`, ...
* Internal-only fix to satisfy type checker variant used by the roblox-cli `convert` command
* `Array.join` will now call `tostring()` on items before adding them

### Added Polyfills
* `String.charCodeAt`, `String.findOr`
* `Array.includes`, `Array.unshift`

## 0.2.4

To be cached to the proxy with a Rotriever RC 4, which will properly filter tests when bundling the artifact.

### Fixes
* Fix for `Array.from` to support `Map` objects

### Added Polyfills
* `Promise` *type-only*, translates relevant portion of Promise type from TypeScript and flowtype, and maps cleanly on top of community Promise libraries.
* `Array.reverse`, `Array.forEach`
* `String.lastIndexOf`, `String.substr`
* `Object` type
* `Error` type

## 0.2.3

### Fixes
* Fix for `instanceof` with objects that have a throwing `__index` metamethod ([#86](https://github.com/Roblox/luau-polyfill/pull/86))
* Move spec file under `__tests__` to fix static analysis error ([#85](https://github.com/Roblox/luau-polyfill/pull/85))

## 0.2.2

### Added Polyfills
* `Map` ([#70](https://github.com/Roblox/luau-polyfill/pull/70))
* `WeakMap` ([#70](https://github.com/Roblox/luau-polyfill/pull/70))
* `Number.NaN` ([#82](https://github.com/Roblox/luau-polyfill/pull/82))

### Fixes
* `Object.keys` should return an empty array for sets ([#71](https://github.com/Roblox/luau-polyfill/pull/71))
* Make third argument of `Array.map(array, callback, this)` optional ([#77](https://github.com/Roblox/luau-polyfill/pull/77))
* `Set` type - add self as first param to Set methods ([#76](https://github.com/Roblox/luau-polyfill/pull/76))
* Override `__tostring` on `Set` so that it prints the contents in a way that matches JS  ([#68](https://github.com/Roblox/luau-polyfill/pull/68))
* Refine typechecking for `String.split` ([#69](https://github.com/Roblox/luau-polyfill/pull/69) and [#78](https://github.com/Roblox/luau-polyfill/pull/78))

* improvements to `util.inspect` ([#68](https://github.com/Roblox/luau-polyfill/pull/68))
  * Print fragmented keys in addition to regular sequential indexes.
  * We now explicitly sort the keys based on alpha-sort, for more stable string comparison in tests/snapshots.
  * If a table overrides tostring, don't append all the raw keys/values.
  * Mixed-index tables now inspect correctly.

## 0.2.1

### Added Polyfills
* `String.split`
* `String.slice`

### Fixes
* `util.inspect` will now emit function names, and use the __tostring metamethod, when printing values, if either are available
* `Set.new` can now take another Set, and is now strongly typed to prevent abuse cases

## 0.2.0

### Changes
Removes `LuauPolyfill.RegExp` so that it can be selectively included as a separate dependency via https://github.com/roblox/luau-regexp.

## 0.1.5

### Added Polyfills
* `String.startsWith`
* `String.endsWith`
* `util.inspect` from nodejs/luvit.io

### Fixes
* All `console` methods will now accept non-strings and print them using `util.inspect`
* Fix Array.reduce to use 1-based indexing (instead of starting from 0)
* `Error` object initializes with an empty string by default

## 0.1.4

### Fixes
* Remove `--!nonstrict` shebangs

## 0.1.3

### Fixes
* Add stacktrace to `Error` object
* Fix infinite loop case for `instanceOf`
* Fix `Set` typing error for newest `roblox-cli`

## 0.1.2

### Added Polyfills
* `extends`
* `instanceof`
* `Array.concat()`
* `Array.join`

### Fixes
* `Error:extend()` removed, changed how inheritance is handled

## 0.1.1

### Added Polyfills
* `Array.sort()`
* `Error.new()`
* `Error:extend()`

### Fixes
* Fixed Luau type analysis regression in `TestMatchers`
* Added a `__tostring` metamethod for `RegExp`

## 0.1.0

### Added Polyfills

* `Array.every()`
* `Array.filter()`
* `Array.find()`
* `Array.findIndex()`
* `Array.from()`
* `Array.indexOf()`
* `Array.isArray()`
* `Array.map()`
* `Array.reduce()`
* `Array.shift()`
* `Array.slice()`
* `Array.some()`
* `Array.splice()`
* `Boolean.toJSBoolean()`
* `Console.makeConsoleImpl()`
* `Error()`
* `Math.clz32()`
* `Number.isNaN()`
* `Number.isInteger()`
* `Number.isSafeInteger()`
* `Number.MAX_SAFE_INTEGER`
* `Number.MIN_SAFE_INTEGER`
* `Number.toExponential()`
* `Object.assign()`
* `Object.entries()`
* `Object.freeze()`
* `Object.is()`
* `Object.keys()`
* `Object.preventExtensions()`
* `Object.seal()`
* `Object.values()`
* `Object.None`
* `RegExp()`
* `RegExp():exec()`
* `RegExp():test()`
* `String.trim()`
* `String.trimEnd()`
* `String.trimStart()`
* `String.trimRight()`
* `String.trimLeft()`
* `Symbol()`
* `Symbol.for_()`
* `TestMatchers.toEqual()`
* `TestMatchers.toThrow()`
* `Timers.clearTimeout()`
* `Timers.setTimeout()`
