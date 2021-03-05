# LuauPolyfills Changelog

## Unreleased

### Added Polyfills
* `String.startsWith`
* `String.endsWith`

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
