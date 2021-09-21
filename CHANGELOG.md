# LuauPolyfills Changelog

## Unreleased

### Fixes
* Internal-only fix to satisfy type checker variant used by the roblox-cli `convert` command

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
