# grammY Rules (Scaling and Runner)

## Canonical docs

- https://grammy.dev/plugins/runner
- https://grammy.dev/advanced/scaling
- https://grammy.dev/plugins/session

## Throughput defaults

- Use `@grammyjs/runner` for concurrent long-polling processing when throughput requires it.
- Keep handlers independent where possible to maximize safe concurrency.
- Measure queue latency and processing duration to tune concurrency settings.

## State consistency

- Add `sequentialize(...)` constraints for updates that can race on shared state.
- If sessions are used with concurrent runner, apply `sequentialize(getSessionKey)` before `session(...)`.
- Keep constraint keys narrowly scoped to preserve parallelism.

## Concurrency design

- Separate CPU-bound or slow I/O work from update handling critical path.
- Keep message ordering requirements explicit by key (chat/user/work item).
- Avoid global serialization unless strictly required; it collapses runner benefits.

## Minimal example

```ts
import { Bot, Context, session } from "grammy";
import { run, sequentialize } from "@grammyjs/runner";

const bot = new Bot(process.env.BOT_TOKEN ?? "");
const storageAdapter = /* your persistent adapter */;

function getSessionKey(ctx: Context) {
  return ctx.chat?.id.toString();
}

bot.use(sequentialize(getSessionKey));
bot.use(session({ getSessionKey, initial: () => ({}), storage: storageAdapter }));

bot.on("message", async (ctx) => {
  await ctx.reply("Processed safely with runner concurrency.");
});

run(bot);
```
