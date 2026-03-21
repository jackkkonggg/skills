# GSAP Rules (Utilities)

## Canonical docs

- https://gsap.com/docs/v3/GSAP/UtilityMethods/
- https://gsap.com/docs/v3/HelperFunctions

## Overview

`gsap.utils` provides pure helper functions — no registration needed. Use in tween vars (function-based values), ScrollTrigger/Observer callbacks, or any JS that drives GSAP.

**Function form pattern:** Most utils accept the value as the **last** argument. Omit it to get a reusable function. Use the function form when the same config is called repeatedly (e.g. in a mousemove handler).

```ts
// Immediate: returns result
gsap.utils.clamp(0, 100, 150); // 100

// Function form: returns reusable function
const c = gsap.utils.clamp(0, 100);
c(150); // 100
```

**Exception:** `random()` uses `true` as the last argument for the function form, not omission.

## Clamping and ranges

### clamp(min, max [, value])

Constrains a value between min and max.

### mapRange(inMin, inMax, outMin, outMax [, value])

Maps a value from one range to another. Use when converting scroll progress, input ranges, or normalized values to animation ranges.

```ts
gsap.utils.mapRange(0, 1, 0, 360, 0.5); // 180
```

### normalize(min, max [, value])

Returns a value normalized to 0–1 for the given range.

### interpolate(start, end [, progress])

Interpolates between two values at a given progress (0–1). Handles numbers, colors, and objects with matching keys.

```ts
gsap.utils.interpolate("#ff0000", "#0000ff", 0.5); // mid color
gsap.utils.interpolate({ x: 0, y: 0 }, { x: 100, y: 50 }, 0.5); // { x: 50, y: 25 }
```

## Random and snap

### random(min, max [, snapIncrement] [, returnFunction]) / random(array [, returnFunction])

Returns a random number in range, or a random element from an array. Pass `true` as the last argument for a reusable function (not omission like other utils).

```ts
gsap.utils.random(-100, 100);              // e.g. 42.7
const rng = gsap.utils.random(0, 500, 10, true);
rng(); // new random value each call, snapped to 10
```

**String form in tween vars:** `"random(-100, 100, 5)"` or `"random([red, blue, green])"` — GSAP evaluates per target.

### snap(snapTo [, value])

Snaps to the nearest multiple or nearest value in an array.

```ts
gsap.utils.snap(10, 23);              // 20
gsap.utils.snap([0, 100, 200], 150);  // 200
```

### shuffle(array)

Returns a new array with elements in random order.

## Distribution

### distribute(config)

Returns a function that assigns values to each target based on array/grid position. Used for advanced staggers and spread-based property assignment.

```ts
gsap.to(".box", {
  scale: gsap.utils.distribute({ base: 0.5, amount: 2.5, from: "center" }),
});
```

Config options: `base`, `amount` (total spread) or `each` (per-target step), `from` (`"start"` | `"center"` | `"edges"` | `"end"` | `"random"` | index | `[x, y]` ratios), `grid` (`[rows, cols]` or `"auto"`), `axis` (`"x"` | `"y"`), `ease`.

## Units and parsing

### getUnit(value)

Returns the unit string (`"px"`, `"%"`, `"deg"`, etc.) of a value. Returns `""` for unitless numbers.

### unitize(value, unit)

Appends a unit to a number. Returns the value unchanged if it already has a unit.

### splitColor(color [, returnHSL])

Converts a color string to `[r, g, b]` (or `[r, g, b, a]`). Pass `true` for HSL output. Works with hex, rgb(), rgba(), hsl(), named colors.

## Arrays and collections

### selector(scope)

Returns a scoped selector function that finds elements only within the given element or ref. Use in components so selectors don't match outside the container.

```ts
const q = gsap.utils.selector(containerRef);
gsap.to(q(".circle"), { x: 100 });
```

### toArray(value [, scope])

Converts selector strings, NodeLists, HTMLCollections, single elements, or arrays to a real array. Optional scope limits selector queries.

### pipe(...functions)

Composes functions left-to-right: `pipe(f1, f2, f3)(value)` returns `f3(f2(f1(value)))`. Use for chaining transforms (normalize -> map -> snap).

```ts
const fn = gsap.utils.pipe(
  gsap.utils.normalize(0, 100),
  gsap.utils.snap(0.1),
);
fn(50); // 0.5
```

### wrap(min, max [, value])

Wraps a value into the range [min, max). Use for infinite scroll or cyclic values.

```ts
gsap.utils.wrap(0, 360, 370); // 10
```

### wrapYoyo(min, max [, value])

Wraps with a yoyo (bounces at ends) instead of jumping.

```ts
gsap.utils.wrapYoyo(0, 100, 150); // 50
```

## Do not

- Do not assume `mapRange` / `normalize` handle units — they work on numbers. Use `getUnit` / `unitize` when units matter.
- Do not forget the function-form pattern: omit the last argument for a reusable function (except `random`, which uses `true`).
- Do not use `gsap.utils.selector()` without a scope — pass a container element or ref.
