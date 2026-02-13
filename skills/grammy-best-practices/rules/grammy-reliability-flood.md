# grammY Rules (Reliability and Flood Limits)

## Canonical docs

- https://grammy.dev/advanced/reliability
- https://grammy.dev/advanced/flood
- https://grammy.dev/plugins/auto-retry
- https://grammy.dev/plugins/transformer-throttler

## Reliability defaults

- Expect transient transport failures and Telegram rate limits in normal operation.
- Retry safely where operations are idempotent or can be made idempotent.
- Keep structured logs for retries, failures, and update IDs.

## Flood-limit strategy

- Handle 429 (`retry_after`) with `auto-retry` or an equivalent retry policy.
- Use throttling to smooth burst traffic and reduce repeated flood-limit hits.
- For broadcast jobs, pace sends and keep bounded batches/checkpoints.

## Failure containment

- Isolate failures so one chat or command path does not stall unrelated updates.
- Keep retry count/time budgets explicit for external side effects.
- Surface persistent failure states for operators rather than silently swallowing errors.

## Minimal example

```ts
import { Bot } from "grammy";
import { autoRetry } from "@grammyjs/auto-retry";

const bot = new Bot(process.env.BOT_TOKEN ?? "");
bot.api.config.use(autoRetry());

bot.command("broadcast", async (ctx) => {
  const targets = [ctx.chat.id];
  for (const chatId of targets) {
    await bot.api.sendMessage(chatId, "Scheduled update");
  }
});
```
