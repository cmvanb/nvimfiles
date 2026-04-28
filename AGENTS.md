# Neovim Configuration Architecture

## Directory Structure

```
nvim/
├── init.lua                    # Bootstrap sequence
├── lua/
│   ├── editor/
│   │   ├── options.lua         # Core editor options
│   │   ├── highlights.lua      # Core UI highlights; note-highlighting autocmd lives here
│   │   └── keymaps.lua         # All keymaps; linebreak sync autocmd lives here
│   ├── plugins/
│   │   ├── init.lua            # Plugin system bootstrap
│   │   └── *.lua               # Lazy specs and plugin config
│   ├── autocommands/
│   │   ├── init.lua            # Explicit autocommand loader
│   │   └── *.lua               # Required manually; not auto-discovered
│   ├── theme/
│   │   ├── system.lua          # External theme bridge
│   │   ├── config.lua          # VT-dependent border config
│   │   └── symbols.lua         # VT/non-VT symbol split
│   └── utils/
│       ├── highlights.lua      # Theme-name -> gui/cterm helper
│       └── plugin_loader.lua   # Plugin discovery contract
└── ftdetect/
    └── *.lua                   # Filetype hooks
```

## Bootstrap Sequence

Order matters for dependency resolution:

1. `init.lua`
2. `utils.disable_builtins`
3. `utils.debug`, `utils.reload`, `utils.reload_config`, `utils.terminal`
4. `editor.options`
5. `editor.highlights`
6. `plugins`
7. `autocommands`
8. `editor.keymaps`

## Features

### System Theme Integration

Theme is consumed from `$XDG_OPT_HOME/theme/theme.lua` — outside the nvim config. `theme/system.lua` prepends that path and does `require('theme')`. Missing color names degrade to `NONE` with `vim.notify` warnings.

`utils/highlights.lua` resolves named colors to both 24-bit and ANSI values automatically.

**Why**: Single source of truth for colors across the entire dotfiles system (Waybar, Alacritty, shell prompts, etc.).

### Dual Environment Support

`is_linux_virtual_terminal()` drives three adaptations:

- **Symbols** (`theme/symbols.lua`): Unicode/Nerd fonts vs ASCII fallbacks
- **Colors** (`utils/highlights.lua`): 24-bit vs 256-color
- **Borders** (`theme/config.lua`): `rounded` normally, `single` on VT

### Plugin Auto-Discovery

`utils/plugin_loader.lua` scans `lua/plugins/**.lua`, skips `init.lua`, requires each file, and aggregates specs with `ipairs`.

**Convention**: Plugin files must return an array-like table — not a bare spec map. Plugin files may also execute code at module scope before lazy setup (e.g. highlights are defined at top level in `plugins/snacks.lua` and `plugins/lualine.lua`).

**Why**: No central plugin list to maintain. Add a plugin file and it is automatically loaded.

### Hot Reload

`_G.reload_config()` reloads editor config, autocommands, and keymaps. Plugin reload is intentionally disabled.

The save-reload autocommand matches `${stdpath('config')}/*.lua` only — it does not match `lua/**`.

**Why**: Iterate on config without restarting Neovim.

### Autocommands

Autocommands belong in `lua/autocommands/`. Some exceptions live close to their relevant code for readability:

- `editor/highlights.lua` — note-highlighting autocmd
- `editor/keymaps.lua` — linebreak sync autocmd
- `ftdetect/*.lua` — filetype hooks

### Extras and Snippets

`extras/` contains inert reference material, mostly old plugin configs.

`snippets/` is consumed by `blink.cmp`'s built-in snippets source. The default search path includes `${stdpath('config')}/snippets`, and `snippets/package.json` is read as a VS Code snippet manifest. `friendly-snippets` is also auto-loaded when present on the runtimepath.

## Extending the System

### Adding a Plugin

1. Create `lua/plugins/myplugin.lua`:
```lua
return {
  'author/plugin-name',
  config = function()
    -- setup
  end
}
```
2. Auto-discovered on next reload/restart

### Adding a Keymap

Add to `editor/keymaps.lua` using helpers:
```lua
nnoremap('<leader>x', function() ... end, 'Description')
```

### Adding a Highlight

Add to `editor/highlights.lua`:
```lua
highlight('MyGroup', {fg = 'system_text', bg = 'primary_0'}, {fg = 'system_text', bg = 'primary_0'})
```

Align the whitespace formatting with the surrounding highlights.
