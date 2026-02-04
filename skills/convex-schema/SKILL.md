---
name: convex-schema
description: Use when defining Convex schemas, validators, indexes, and TypeScript types, including edits to `convex/schema.ts`, adding indexes, or modeling data types.
---

# Convex Schema

## Schema Location

- Always define the schema in `convex/schema.ts`.
- Import schema helpers from `convex/server`.

## System Fields

- `_creationTime`: `v.number()`.
- `_id`: `v.id(tableName)`.

## Index Naming And Order

- Include all index fields in the index name (e.g. `by_field1_and_field2`).
- Query index fields in the same order as defined.
- Create separate indexes for different field orders.

## Validators And Types

- Use `v.id(tableName)` for ids.
- Use `v.null()` for null.
- Use `v.int64()` for int64.
- Use `v.record()` for records; keys must be ASCII, nonempty, and not start with `$` or `_`.

## TypeScript Type Guidance

- Prefer `Id<"table">` from `./_generated/dataModel` for ids.
- For record types, match validators to types: `v.record(v.id("users"), v.string())` -> `Record<Id<"users">, string>`.
- Use `as const` for discriminated union string literals.
- Use `Array<T>` and `Record<Key, Value>` explicit type annotations when needed.

## References

- Read `references/convex_rules.md` for the full rules and examples.
