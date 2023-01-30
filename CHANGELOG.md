# LuauPolyfills Changelog

## Unreleased

## 1.2.2

* Optimize charCodeAt by removing an iterations over all codepoints in the input string.

## 1.2.1

* :hammer_and_wrench: Error and AssertionError use global suffix ([#178](https://github.com/Roblox/luau-polyfill/pull/178))

## 1.2.0

* add `flat` to `Array` type
* add `flatMap` to `Array` type

## 1.1.2

* slightly optimize `instanceof` loop detection
* Export Symbol from a separate repo to work around rotriever limitations, reduce total available versions for Symbol, and keep the global registry working.
* Fix lint in `Map` implementation around type of `next`

## 1.1.1

* When `__DEV__` global is true, the Map object will no longer overflow the C stack when you access a field on it after incorrectly calling table.clear(). It now asserts with actionable information.
* the `Map` constructor will now correctly take a `Map`, cloning the keys and values correctly.
* `Map.new` will now include more information that more closely matches JS standards when given invalid arguments.
* Add `Error.__recalculateStacktrace` static method to allow recalculating of the previously captured stacktrace to account for possibly new `message` and `name`

## 1.1.0

* Add WeakMap type to ES7Types package
* Replace custom implementation of `Math.countlz` with the new engine `bit32.countlz` function
* Fix `indexOf` to be accessible from `String`
* Refactor structure to a rotriever workspace
* Fix Error stacktrace to include error name and message

## 1.0.0

* add `indexOf` method to `String` type

## 0.4.2

### Added Polyfills

* add `includes` method to `String` type

### Changes

* restructured some internals to avoid circular dependency issues

## 0.4.1

* fix `WeakMap` typing - distinguish private and public API

## 0.4.0

### Added Polyfills

* add `getStatus` and `awaitStatus` methods to `Promise` type

### Changes

* Use Luau's generalized iteration feature where possible, resulting in up to 50% better benchmark performance in some scenarios.
* Runtime optimizations to avoid empty table assignments unnecessarily, using the faster table.clone() when convenient.
* `Array.findIndex` will now typecheck the predicate function to ensure types match the supplied `Array<T>`
* `Array.reduce` will now typecheck the predicate function and initial values to ensure types match the supplied `Array<>`
* `Array.from` will now type the return value correctly when a map function parameter is omitted. Until Luau adds better support for function overloads, you may now need to manually annotate the return value in some scenarios.
* `Array.includes` and `Array.indexOf` will now typecheck the searched element is the same type as the supplied containing `Array<>`
* `Array.reverse`, `Array.splice`, `Array.sort`, `Array.shift`, `Array.unshift` will no longer erase the element type of the supplied `Array<>`
* `AssertionError.new` no longer requires the `operation` field, and the `AssertionError` instance field is now nil-able, matching upstream nodejs.
* `Object.entries` and `Object.values` now returns a more specifically-typed `Array<>` based on the supplied Object
* `Object.freeze` and `Object.seal` should now retain more type fidelity of the input parameter to the return value
* `Map`, `WeakMap`, and `Set` exported tables are now strongly-typed, which mostly aids typechecking of the backing implementation detail.
* `WeakMap.new` is now generic, so the return value can be force-cast to specific Key and Value types by users.
* `String.split` now accepts a `limit` parameter, to limit the number of split strings returned.
* `String.split` will now escape Lua pattern match characters in the `pattern` parameter, allowing for splitting on `%` and `.` characters.
* `String.split` behavior now matches JavaScript when passed an empty pattern.
* `clearTimeout` and `clearInterval` will no longer crash when given `nil`, and just be a no-op.

### Deprecations

* `Map<>:ipairs()` and `Set<>:ipairs()` will be removed in a future version of the library, in favor of the significantly better-performing `__iter` metamethod. Please migrate your loops that use these methods to instead used the generalized iteration approach:

```lua
for key, value in myMap do
end
```

## 0.3.4

### Added Polyfills

* add `await` method to `Promise`
* add multi-return support for `Promise.expect`

## 0.3.3

### Added Polyfills

* implement `AssertionError`

## 0.3.2

### Added Polyfills

* implement `setInterval` and `clearInterval`
* implement `encodeURIComponent`, integration tested in Apollo GraphQL project

### Changes

* `Symbol` is now typed to return `any` when indexed with a string, allowing code using `Symbol.species` and the like to type check without casts in the library consumer code.

## 0.3.1

### Changes

* `inspect` now accepts an optional options table with a depth option, which defaults to `2`.
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

Removes `LuauPolyfill.RegExp` so that it can be selectively included as a separate dependency via <https://github.com/roblox/luau-regexp>.

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
