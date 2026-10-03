# QuestItemLeftovers

Tells you whether the quest-related items sitting in your bags should be kept
or can safely be discarded. Hover any item and it annotates the tooltip, or run
a full bag scan with `/qil scan`.

Built for **WoW Forever** (Interface 16001).

## How it works

QuestItemLeftovers cross-references three sources:

- **QuestieDB** — static quest/item relationships (which quests use which items).
- **Blizzard's live quest log** — what you currently need for your active quests.
- **Your bags** — which quest items you actually have.

For every quest item it reports one of:

- **KEEP** — needed by an active quest (shows how many you have vs. need).
- **EXCESS AVAILABLE** — you hold more than any active quest requires.
- **KEEP FOR NOW** — a source item for an active quest.
- **POSSIBLE QUEST USE** — linked to an unfinished quest.
- **QUEST USE UNKNOWN** — a quest item with no known mapping.
- **LIKELY SAFE TO DELETE** — no unfinished quest needs it.

## Requirements

- [QuestieDB](https://github.com/Questie/) (required dependency).

## Install

1. Download the latest release.
2. Extract so that you end up with `QuestItemLeftovers/` inside your
   `World of Warcraft/_retail_/Interface/AddOns/` folder.
3. Restart WoW or reload your UI (`/reload`).

## Commands

- `/qil scan` — scan your bags and print a summary to chat.
- `/qil refresh` — rebuild the QuestieDB index and quest cache.

## Localization

Supported locales: `enUS`, `deDE`, `frFR`, `esES`, `ptBR`, `itIT`, `ruRU`,
`koKR`, `zhCN`, `zhTW`. English is the fallback. Add or fix translations in
`Localization.lua`.

## License

[MIT](LICENSE)
