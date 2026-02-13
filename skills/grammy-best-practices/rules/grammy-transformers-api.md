# grammY Rules (Transformers and API)

## Canonical docs

- https://grammy.dev/advanced/transformers
- https://grammy.dev/plugins/auto-retry
- https://grammy.dev/plugins/transformer-throttler
- https://grammy.dev/advanced/flood

## Transformer strategy

- Use API transformers only for cross-cutting request behavior (retries, throttling, logging, mocking).
- Keep transformer stack explicit and documented because order affects behavior.
- Prefer official plugins before custom transformer code when solving common concerns.

## Retry and throttling

- Use `auto-retry` to handle 429 `retry_after` responses safely.
- Use transformer throttling when sustained traffic requires paced outgoing requests.
- Combine retries and throttling deliberately; monitor latency tradeoffs under load.

## Upload and retry caveat

- Avoid non-recreatable one-shot streams for uploads when retries may happen.
- Prefer `InputFile` from file paths or recreatable sources so retries can resend safely.
- Keep payload sizes and upload strategy aligned with runtime memory constraints.

## Minimal example

```ts
import { Bot, InputFile } from "grammy";
import { autoRetry } from "@grammyjs/auto-retry";
import { apiThrottler } from "@grammyjs/transformer-throttler";

const bot = new Bot(process.env.BOT_TOKEN ?? "");

bot.api.config.use(autoRetry());
bot.api.config.use(apiThrottler());

bot.command("send-report", async (ctx) => {
  await ctx.replyWithDocument(new InputFile("./reports/latest.pdf"));
});
```
