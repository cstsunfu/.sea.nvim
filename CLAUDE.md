# CLAUDE.md

## Project Overview

This repository is a personal Neovim configuration.

Core goals:
- Fast startup with lazy-loading.
- Controllable memory usage when running multiple independent Neovim instances.
- Builtin LSP workflow with explicit lifecycle control.

## Useful Commands

### Neovim runtime checks
- `:checkhealth`
- `:Lazy sync`
- `:Lazy profile`
- `:Mason`
- `:LspInfo`

### LSP lifecycle commands
- `:LspStartCurrent` — Start configured LSP clients for current buffer.
- `:LspStopAll` — Stop active LSP clients attached to current buffer.
- `:LspStopInactive` — Stop LSP clients not attached to any loaded buffer.

## Multi-instance Memory Strategy

To reduce memory usage when many Neovim instances are open:

1. Disable automatic LSP process start by default.
   - All configured Mason servers should use `autostart = false` unless explicitly required.
2. Keep `mason-lspconfig` automatic enabling disabled.
   - Use `automatic_enable = false` in `mason_lspconfig.setup`.
3. Prefer manual LSP startup for active work buffers.
4. Stop inactive LSP clients automatically on idle/focus-loss.
5. Keep AI-related plugins lazy-loaded and command/event-triggered.

## Keymaps (LSP lifecycle)

- `;ls` -> `:LspStartCurrent`
- `;lS` -> `:LspStopAll`
- `;li` -> `:LspStopInactive`

## Configuration Conventions

1. Use lazy-loading for plugins whenever possible.
2. Avoid duplicate LSP server setup across files.
   - Keep LSP server registration centralized in `lua/configure/lsp_config/init.lua`.
3. Use English comments in code.
4. Prefer targeted edits (small scoped changes) over broad rewrites.
5. Do not introduce always-on background services without clear need.

## Notes

- `ensure_installed` in Mason controls binary installation, not runtime process spawning.
- `autostart = false` controls whether LSP processes auto-start for matching filetypes.

