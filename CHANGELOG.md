# LuauPolyfills Changelog

# Unreleased

### Added Polyfills
* `String.split`
* `String.slice`

### Fixes
* `util.inspect` will now emit function names, and use the __tostring metamethod, when printing values, if either are available
* `Set.new` can now take another Set, and is now strongly typed to prevent abuse cases

# 0.2.0

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
