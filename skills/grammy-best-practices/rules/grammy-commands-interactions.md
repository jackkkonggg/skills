# grammY Rules (Commands and Interactions)

## Canonical docs

- https://grammy.dev/guide/commands
- https://grammy.dev/plugins/commands
- https://grammy.dev/guide/filter-queries
- https://grammy.dev/guide/context
- https://grammy.dev/ref/core/inlinekeyboard

## Command architecture

- Use command handlers for explicit intents and narrow filter handlers for non-command updates.
- Keep command parsing explicit and validate required arguments before invoking side effects.
- Prefer one responsibility per command handler; delegate business logic to services.

## Callback and keyboard handling

- Use callback query filters to keep button actions scoped and readable.
- Call `answerCallbackQuery` promptly for interactive buttons to avoid stale client UX.
- Keep callback payloads compact and parseable; use stable prefixes for routing.

## Interaction safety

- Validate actor/chat context for destructive actions (admin-only, owner-only, tenant checks).
- Do not trust callback payloads blindly; treat them as user-controlled input.
- Keep edits and replies idempotent where possible to simplify retries.

## Minimal example

```ts
import { Bot, InlineKeyboard } from "grammy";

const bot = new Bot(process.env.BOT_TOKEN ?? "");

bot.command("menu", async (ctx) => {
  const kb = new InlineKeyboard().text("Refresh", "menu:refresh");
  await ctx.reply("Choose an action", { reply_markup: kb });
});

bot.callbackQuery(/^menu:/, async (ctx) => {
  await ctx.answerCallbackQuery();
  if (ctx.callbackQuery.data === "menu:refresh") {
    await ctx.editMessageText("Menu refreshed.");
  }
});
```
