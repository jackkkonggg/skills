# grammY Rules (Sessions and State)

## Canonical docs

- https://grammy.dev/plugins/session
- https://grammy.dev/guide/context
- https://grammy.dev/advanced/scaling

## Session defaults

- Define explicit session types and a deterministic `initial` function.
- Use persistent storage adapters for production workloads.
- Keep session payloads small and scoped to conversational or per-actor state.
- Choose `getSessionKey` intentionally (chat, user, or composite keys) based on isolation needs.

## Production storage guidance

- Do not rely on in-memory default storage outside local development.
- Ensure storage operations and keying strategy align with deployment topology (single process vs horizontal scale).
- Keep session schema evolution backward-compatible when rolling out bot updates.

## Concurrency caveat

- If updates are processed concurrently, protect state consistency with sequential constraints for shared session keys.
- Keep high-contention writes short and deterministic to reduce lock duration when sequentializing.

## Minimal example

```ts
import { Bot, Context, session, SessionFlavor } from "grammy";

interface SessionData {
  count: number;
}
type BotContext = Context & SessionFlavor<SessionData>;

const bot = new Bot<BotContext>(process.env.BOT_TOKEN ?? "");
const storageAdapter = /* your persistent adapter */;

bot.use(
  session({
    initial: () => ({ count: 0 }),
    storage: storageAdapter,
  }),
);

bot.on("message", async (ctx) => {
  ctx.session.count += 1;
  await ctx.reply(`Seen ${ctx.session.count} messages`);
});
```
