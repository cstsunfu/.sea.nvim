# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal Neovim configuration built on lazy.nvim. Core goals: fast startup with lazy-loading, controllable memory usage across multiple Neovim instances, and builtin LSP with explicit lifecycle control.

## Useful Commands

### Neovim runtime checks
- `:checkhealth` — Neovim health diagnostics (`:LspInfo` is only an alias for `:checkhealth vim.lsp` now)
- `:Lazy sync` / `:Lazy profile` — Plugin management and startup profiling
- `:Mason` — LSP/formatter binary management

### LSP lifecycle commands
- `:LspStartCurrent` — Start the LSP clients configured for the current filetype
- `:LspStopAll` — Stop all active LSP clients (including Copilot)
- `:LspStopInactive` — Stop LSP clients not attached to any loaded buffer

### Formatting
- `:FormatDisable[!]` / `:FormatEnable` — toggle autoformat-on-save (`!` = buffer-local)
- `<leader>=` — format the buffer/selection on demand (conform.nvim)

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
  -> configure.<colorscheme>.setup(vim.g.style)  -- Loads the theme picked by core/themes.lua
  -> core/gui.lua                 -- Neovide-specific settings (only when running in Neovide)
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

`core/plugins.lua` iterates `vim.g.feature_groups` (defined in `core/init.lua`), requires each config module, merges group-level overrides (like `enabled`, `lazy`), and passes the collected list to `lazy.setup()`. The `loaded_plugins` table tracks which plugins are active at runtime. **A group entry overrides the `enabled` flag inside the plugin file**, and `create_mapping()` calls `.mapping()` on every plugin whose group entry is `enabled = true`, so every config file must define `plugin.mapping` (even as an empty function).

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

- Servers are registered via `vim.lsp.config()` (Neovim 0.11+ native API); capabilities are `cmp_nvim_lsp.default_capabilities()` computed in `configure/lsp_config/init.lua`, and hover/signature/diagnostic handlers live in `configure/lsp_config/default_setting.lua`
- Mason installs the binaries; `mason-lspconfig` runs with `automatic_enable = true`
- **The per-server `autostart` field is documentation only**: it is stored in the config table, but Neovim 0.11 does not read it, and `automatic_enable = true` enables every installed server for its filetypes. Treat `;ls` / `:LspStartCurrent` as "start if not already running", not as the only way servers start
- `filetype_servers` in the mapping section maps filetypes to server names for manual start
- Clients stop after 30 min idle and on `FocusLost`; they resume on `FocusGained`/`BufEnter`
- Neovim's own deprecation warnings are muted by `vim.deprecate = function() end` in `init.lua`

### Markdown rendering

| Buffer | Renderer | Notes |
|--------|----------|-------|
| markdown files | `render-markdown.nvim` (`configure/render_markdown.lua`) | headings/bullets are left literal; code blocks/tables still render; skips `vim.b.large_buf` and `nofile` buffers; `render_modes` includes insert/visual |
| Avante sidebar (`ft=Avante`) | `markview.nvim` + `markview-smart-tables.nvim` (`configure/avante.lua`) | tables wider than the sidebar are squeezed; render is skipped while the answer streams and re-run once idle |

`headlines.nvim` is disabled (feature-frozen upstream). The custom markdown treesitter query lives in `lua/util/markdown_query.lua` and is installed by `configure/tree_sitter.lua`; markview rewrites the global markdown query when it attaches, so `configure/avante.lua` puts it back afterwards. Never inline that query again in two places.

### Avante (`configure/avante.lua`)

Heavily customised, all via monkeypatches inside the plugin config:

- **Prompt**: `Path.prompts.render_mode("agentic")` is replaced by a compact editor-agent prompt (plus avante's rendered environment block). Project/global `*.avanterules` still win when present.
- **Tools**: `disabled_tools` removes the bash duplicates (git/mv/mkdir/python/undo/think/…); `add_file_to_context` and `remove_file_from_context` cannot be disabled (avante appends them after the filter).
- **Model**: provider `ds41f` (OpenAI-compatible) with `context_window = 1048576`, streaming via `--no-buffer`, `/effort` slash command for the reasoning knob. The endpoint, model and key-variable name come from `AVANTE_ENDPOINT` / `AVANTE_MODEL` / `AVANTE_API_KEY_NAME`; the repository holds no company-specific defaults.
- **History**: message uuids are regenerated with a seeded RNG (upstream `Utils.uuid` reuses Lua's unseeded `math.random`, which overwrote messages in resumed chats); an empty in-memory history is reloaded from disk on `BufEnter`; `get_latest_filename` picks the newest numbered chat file.
- **Rendering**: only the changed tail of the answer buffer is written (`Utils.update_buffer_lines` prefix diff), the forced `:redraw` is skipped, viewport updates are throttled to 120 ms, and the status indicator is drawn in the result window's winbar instead of a `virt_lines` extmark.

### Recent files (`util/recent.lua`, `util/project.lua`)

telescope-frecency keeps its database in `stdpath("state")` (`file_frecency_v2.bin`, v2 backend), so all Neovim instances on the machine share it across tmux sessions and projects; instances watch the file and reload on change.

| Key | Action | Scope |
|-----|--------|-------|
| `;fr` | frecency picker | global |
| `;fh` | grep inside recently used files | global |
| `;fR` | recent files picker | current project root |
| `;fH` | grep inside recently used files | current project root |

### Formatter (`configure/formatter.lua`)

conform.nvim runs on `BufWritePre`; **markdown is excluded** (prettier rewraps prose on every save) and is only formatted on demand with `<leader>=`. Python is formatted automatically with isort + black.

## Multi-instance Memory Strategy

1. LSP clients stop on idle (30 min) and on `FocusLost`, and resume when the window regains focus.
2. Server registration does not stop `mason-lspconfig` from enabling installed servers for their filetypes — check `:checkhealth vim.lsp` / `lua/configure/lsp_config/init.lua` before assuming a server is dormant.
3. AI plugins (avante, codecompanion, copilot) are lazy-loaded and command/event-triggered.
4. Markdown previewing (markview/render-markdown) is skipped for large buffers and only runs when a preview buffer is visible.

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
| `lua/util/` | Helpers: `global` (large buffers, misc), `highlight`, `project`, `recent`, `markdown_query`, path/json utils |
| `lua/hack/` | Custom features (Pomodoro timer) |
| `ftplugin/` | Filetype-specific settings (lua, python, vimwiki) |
| `readme.md` | User-facing documentation (tracked; keep it in sync with keymaps) |
| `lazy-lock.json` | Plugin version lockfile (git-ignored in this repository) |

## Notes

- `ensure_installed` in Mason controls binary installation, not runtime process spawning.
- macOS Alt key mappings use Unicode characters (`¬`, `˚`, `˙`, `∆`) plus standard `<A-x>` fallbacks for terminals configured to send Meta.
- Large files (>2MB or lines >2000 chars) auto-disable syntax/treesitter/etc via `enable_large_buf()`, which sets the buffer-local `vim.b.large_buf` flag that `tree_sitter.lua` and `render_markdown.lua` read.
- Inactive windows get a `DarkNormal` highlight; side filetypes (NvimTree, Avante, etc.) keep their own background.
- `cmds` in the repo root is an empty stray file, unrelated to the config.
