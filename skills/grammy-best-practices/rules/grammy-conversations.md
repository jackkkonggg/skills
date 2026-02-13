# grammY Rules (Conversations)

## Canonical docs

- https://grammy.dev/plugins/conversations
- https://grammy.dev/guide/context
- https://grammy.dev/advanced/middleware

## Setup order and typing

- Install `conversations()` before registering any `createConversation(...)` middleware.
- Keep outside context and inside conversation context types explicit in TypeScript.
- Keep conversation entrypoints narrow and route all multi-step flow through named conversations.

## Flow control

- Define explicit exits (`/cancel`, timeout branches, terminal states) for every conversation.
- Validate user input at each step before moving to the next state.
- Keep conversation-local side effects minimal and move external effects behind helpers/services.

## Plugin caveats in conversations

- Use conversation `plugins` to install middleware behavior for conversation context objects.
- Install transformer plugins on each conversation `ctx.api` when needed in conversation scope.
- Keep plugin order deterministic to avoid hidden behavior differences between normal and conversation handlers.

## Minimal example

```ts
import { Bot, Context } from "grammy";
import {
  Conversation,
  ConversationFlavor,
  conversations,
  createConversation,
} from "@grammyjs/conversations";

type BotContext = ConversationFlavor<Context>;
type Convo = Conversation<BotContext, Context>;

const bot = new Bot<BotContext>(process.env.BOT_TOKEN ?? "");

async function signup(conversation: Convo, ctx: Context) {
  await ctx.reply("What is your email?");
  const next = await conversation.wait();
  await next.reply(`Saved: ${next.message?.text ?? "unknown"}`);
}

bot.use(conversations());
bot.use(createConversation(signup));
bot.command("signup", async (ctx) => {
  await ctx.conversation.enter("signup");
});
```
