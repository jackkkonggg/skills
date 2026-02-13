# grammY Rules (Deployment and Operations)

## Canonical docs

- https://grammy.dev/hosting/checklist
- https://grammy.dev/guide/deployment-types
- https://grammy.dev/guide/deployment-types#webhooks
- https://grammy.dev/guide/deployment-types#long-polling
- https://grammy.dev/guide/errors

## Deployment model choices

- Choose long polling for simpler worker-style deployments and webhooks for request-driven/serverless setups.
- Keep runtime-specific bootstrap small and move business logic to shared bot modules.
- Store bot token and operational secrets in environment variables with fail-fast startup checks.

## Webhook operations

- Acknowledge webhook requests quickly and avoid long-running work in the HTTP response path.
- Offload expensive follow-up work to queues/workers/background tasks.
- Keep webhook endpoint routes explicit and protected by platform/network controls.

## Long-polling operations

- Register graceful shutdown handlers for `SIGINT` and `SIGTERM`.
- Stop runner/polling cleanly before process exit to reduce duplicate update handling.
- Keep readiness/liveness aligned with bot startup and stop lifecycle.

## Minimal example

```ts
import express from "express";
import { Bot, webhookCallback } from "grammy";

const bot = new Bot(process.env.BOT_TOKEN ?? "");
const app = express();

bot.command("health", async (ctx) => {
  await ctx.reply("ok");
});

app.post("/webhook", webhookCallback(bot, "express"));
app.listen(process.env.PORT ?? 3000);

process.once("SIGINT", () => bot.stop());
process.once("SIGTERM", () => bot.stop());
```
