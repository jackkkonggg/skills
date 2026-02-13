# grammY Rules (Core and Middleware)

## Canonical docs

- https://grammy.dev/guide
- https://grammy.dev/advanced/middleware
- https://grammy.dev/guide/errors
- https://grammy.dev/guide/filter-queries

## Bot setup defaults

- Create one bot instance per token and register middleware in deliberate order.
- Install foundational middleware (`session`, auth checks, tracing) before command/update handlers.
- Keep middleware composable and small; move heavy logic to dedicated helper functions.
- Treat every update as untrusted input and validate assumptions before side effects.

## Error and async handling

- Always register `bot.catch(...)` in production code.
- Distinguish `GrammyError` (Telegram API request issues) from `HttpError` (transport issues) for observability.
- Always `await` Bot API calls (`ctx.reply`, `ctx.api.*`) and async storage/service calls.
- Fail fast with actionable logs that include `update_id` when available.

## Handler design

- Prefer narrow filters (`bot.command`, `bot.callbackQuery`, `bot.on`) over broad catch-all handlers.
- Keep handler bodies short; orchestrate flow in services so behavior remains testable.
- Use middleware to set shared context state instead of recomputing per handler.

## Minimal example

```ts
import { Bot, GrammyError, HttpError } from "grammy";

const token = process.env.BOT_TOKEN;
if (!token) throw new Error("BOT_TOKEN is unset");

const bot = new Bot(token);

bot.command("start", async (ctx) => {
  await ctx.reply("Hello from grammY.");
});

bot.catch((err) => {
  const id = err.ctx.update.update_id;
  const e = err.error;
  console.error(`Failed update ${id}`);
  if (e instanceof GrammyError) console.error("Telegram error:", e.description);
  else if (e instanceof HttpError) console.error("Network error:", e);
  else console.error("Unknown error:", e);
});
```
