# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal Neovim configuration built on lazy.nvim. Core goals: fast startup with lazy-loading, controllable memory usage across multiple Neovim instances, and builtin LSP with explicit lifecycle control.

## Useful Commands

### Neovim runtime checks
- `:checkhealth` — Neovim health diagnostics
- `:Lazy sync` / `:Lazy profile` — Plugin management and startup profiling
- `:Mason` — LSP/formatter binary management
- `:LspInfo` — Active LSP client status

### LSP lifecycle commands
- `:LspStartCurrent` — Start configured LSP clients + Copilot for current buffer
- `:LspStopAll` — Stop all active LSP clients (including Copilot)
- `:LspStopInactive` — Stop LSP clients not attached to any loaded buffer

## Architecture

### Boot sequence (`init.lua` -> `core/init.lua`)

```
init.lua                          -- Sets HOME_PATH, CONFIG globals; bootstraps lazy.nvim
  -> core/default.lua             -- Vim options, leader keys, autocmds (large file handling, autochdir, cursorline)
  -> core/user.lua.setup()        -- User config; calls local.lua if present (machine-specific, not tracked by git)
  -> core/plugins.lua.setup()     -- Builds plugin list from feature groups, calls lazy.setup()
  -> hack/init.lua.setup()        -- Pomodoro timer setup
  -> core/plugins.create_mapping()-- Calls .mapping() on every loaded plugin config
  -> hack/init.lua.create_mapping()
  -> core/mapping.lua.setup()     -- Registers prefix groups with which-key
  -> colorscheme setup            -- Loads theme based on vim.g.colorscheme / vim.g.style
  -> core/gui.lua                 -- Neovide-specific settings (if applicable)
  -> core/after.lua               -- Post-load highlight adjustments (delayed via timer)
  -> core/user.lua.after()        -- User after-hook
```

### Plugin configuration pattern

Every plugin config in `lua/configure/` follows the same contract:

```lua
local plugin = {}
plugin.core = {
    "author/plugin-name",
    event = "...",               -- lazy-loading trigger
    config = function() end,     -- setup code
}
plugin.mapping = function()      -- keymaps via core.mapping.register()
end
return plugin
```

`core/plugins.lua` iterates `vim.g.feature_groups` (defined in `core/init.lua`), requires each config module, merges group-level overrides (like `enabled`, `lazy`), and passes the collected list to `lazy.setup()`. The `loaded_plugins` table tracks which plugins are active at runtime.

### Feature group system (`core/init.lua`)

Plugins are organized into groups controlled by `vim.g.feature_groups`:
`default`, `lsp` ("builtin"/"coc"/nil), `colorschemes`, `beauty_vim`, `file_and_view`, `special_for_language`, `debug_adapter`, `org_my_life`, `enhance`, `git`.

Setting a group to `false`/`nil` disables all its plugins. The `lsp` group uses a string value to switch between "builtin" and "coc" implementations.

### Keymap system (`core/mapping.lua`)

`mapping.register()` is the central keymap registration function. It:
- Tracks all registered mappings per mode to **detect conflicts at load time**
- Auto-registers 2+ key sequences with which-key for prefix hints
- Supports multi-mode registration via table (`mode = {"n", "v"}`)

Leader: `;` / LocalLeader: `space`. The `'` key is remapped to `;` in normal/visual mode.

### LSP setup (`configure/lsp_config/init.lua`)

- Servers are registered via `vim.lsp.config()` (Neovim 0.11+ native API)
- Mason installs binaries; `mason-lspconfig` with `automatic_enable = true` handles registration
- `autostart` per-server controls whether LSP auto-attaches on filetype match
- `LspStartCurrent` uses `vim.lsp.enable()` to start servers on demand
- A `filetype_servers` table in the mapping section maps filetypes to server names
- Auto-stop on 30 min idle and on `FocusLost`; auto-resume on `FocusGained`/`BufEnter`

### Theme system (`core/themes.lua`)

Theme selected by `GLOBAL_THEME` env var (`"light"` -> material_light, else material_palenight). Highlight overrides in `core/after.lua` run on a delayed timer to ensure colorscheme is fully loaded.

## Multi-instance Memory Strategy

1. All Mason servers use `autostart = false` unless explicitly required (pyright, jsonls, sqlls, clangd, ts_ls are exceptions).
2. LSP clients stop on idle (30 min) and focus loss.
3. AI plugins (avante, codecompanion, copilot) are lazy-loaded and command/event-triggered.
4. Prefer manual LSP startup via `;ls` for active work buffers.

## Configuration Conventions

1. Use lazy-loading for plugins whenever possible.
2. Keep LSP server registration centralized in `lua/configure/lsp_config/init.lua` — do not duplicate across files.
3. Use English comments in code.
4. Prefer targeted edits (small scoped changes) over broad rewrites.
5. Do not introduce always-on background services without clear need.
6. `user.lua` is tracked by git (general user config); `local.lua` is machine-specific and git-ignored.

## Key Paths

| Path | Purpose |
|------|---------|
| `lua/core/` | Initialization, vim settings, plugin loader, keymap system |
| `lua/configure/` | One file per plugin (120+ configs) |
| `lua/configure/lsp_config/` | LSP server definitions and default LSP settings |
| `lua/util/` | Helpers: global functions, highlight manipulation, path/json utils |
| `lua/hack/` | Custom features (Pomodoro timer) |
| `ftplugin/` | Filetype-specific settings (lua, python, vimwiki) |
| `lazy-lock.json` | Plugin version lockfile |

## Notes

- `ensure_installed` in Mason controls binary installation, not runtime process spawning.
- `autostart = false` controls whether LSP processes auto-start for matching filetypes.
- macOS Alt key mappings use Unicode characters (`¬`, `˚`, `˙`, `∆`) plus standard `<A-x>` fallbacks for terminals configured to send Meta.
- Large files (>2MB or lines >2000 chars) auto-disable syntax/treesitter/etc via `enable_large_buf()`.
- Inactive windows get a `DarkNormal` highlight; side filetypes (NvimTree, Avante, etc.) keep their own background.
