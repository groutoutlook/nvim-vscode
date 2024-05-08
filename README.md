# Neovim VSCode config

This repository contains my Neovim configuration which also has parallel configuration for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim). Tried to keep the experience as close as possible for both platforms. Keybinds are meant to be Neovim first, i.e. taking Neovim keybinds to VSCode rather than the other way around.

## VSCode settings

`settings.json`

```jsonc
{
  // Neovim
  "vscode-neovim.compositeKeys": {
    "jk": {
      "command": "vscode-neovim.escape"
    }
  },
  "extensions.experimental.affinity": {
    "asvetliakov.vscode-neovim": 1
  }
}
```

## Todo

- notify if no toggleterm windows available, toggleterm doesnt toggle if processes are not running
- Nvim doesnt exit properly, searching in git log fails, not disposing running gdb server
- non git dirs break telescope file search if a file is opened
- use trouble keybinds for quickfix
- Create installation guide and dependencies
- harpoon not adding relative file path
- searching from telescope in dashboard breaks colors (because lsp is loaded after file is opened?)
- loading session does the same as above
- cppcheck
- reorder overseer actions
- add title for overseer, vista
- toggle dap virtual text (blocked see issue)
- start a custom terminal for builds with ft set to log and autoscroll off
