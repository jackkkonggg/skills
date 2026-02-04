# Convex Rules (Schema + Types)

## Validator guidelines
- `v.bigint()` is deprecated; use `v.int64()`.
- Use `v.record()` for record types; `v.map()` and `v.set()` are not supported.

## Schema guidelines
- Always define schema in `convex/schema.ts`.
- Import schema helpers from `convex/server`.
- System fields: `_creationTime` -> `v.number()`, `_id` -> `v.id(tableName)`.
- Index naming should include all fields: `by_field1_and_field2`.
- Index field order matters; create separate indexes for different orders.

## TypeScript guidelines
- Use `Id` from `./_generated/dataModel` for ids, e.g. `Id<"users">`.
- Match `v.record()` to `Record<Id<"users">, string>` when using `v.record(v.id("users"), v.string())`.
- Use `as const` for discriminated union string literals.
- Use `Array<T>` and `Record<Key, Value>` explicit types when needed.
- Add `@types/node` to `package.json` when using Node built-ins.
