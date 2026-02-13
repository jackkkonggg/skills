# grammY Rules (Files and Media)

## Canonical docs

- https://grammy.dev/plugins/files
- https://grammy.dev/guide/files
- https://grammy.dev/ref/core/inputfile

## File handling defaults

- Use official file helpers for download and metadata resolution instead of ad-hoc URL logic.
- Treat Telegram file IDs as references; resolve to files/paths only when needed.
- Keep temporary file lifecycle explicit (create, process, delete) to avoid disk leaks.

## Download and upload guidance

- Use `hydrateFiles` when convenient download helpers improve readability and reliability.
- Prefer writing downloads to controlled paths in production workflows.
- Prefer `InputFile` with filesystem paths or buffers that can be recreated if retries are enabled.

## Operational safety

- Validate media type and size before expensive processing.
- Apply authorization checks before downloading or redistributing user-provided files.
- Keep external processing of downloaded media bounded by timeout and size limits.

## Minimal example

```ts
import { Bot, Context, InputFile } from "grammy";
import { FileFlavor, hydrateFiles } from "@grammyjs/files";

type BotContext = FileFlavor<Context>;
const bot = new Bot<BotContext>(process.env.BOT_TOKEN ?? "");

bot.api.config.use(hydrateFiles(bot.token));

bot.on(":photo", async (ctx) => {
  const file = await ctx.getFile();
  const downloadedPath = await file.download("./tmp/incoming.jpg");
  await ctx.replyWithDocument(new InputFile(downloadedPath));
});
```
