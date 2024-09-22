# Neovim VSCode config

- This repository contains my Neovim configuration, including parallel settings for the [Neovim Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim).
  - Adjust it to be cross-platform.
  - Heavily favored VSCode style of editting method.
  - NeoVim is more like, for navigation and some more complex shorthand
    - that I want to multiplex on VSCode.

## Reason

- I'm familiar more with NeoVim-Style of navigation, but it's really sucked up that I have to edit in Visual Studio all the time. Every Vim integration solution in Visual Studio is just bad, but I couldnt leave them there because its debugger and almost everything is just right.
- As a result, now I'm more into open files on VSCode, and with this VSCode-Neovim extension, I could move as freely as ever.

## Installation

### Linux(Ubuntu)

- `sudo snap install neovim --classic`
  - Or just clone nightly and `make install`.
- `sudo apt install fd-find ripgrep clang gcc make python3 python-is-python3 lua5.1 unzip`
- [Nodejs](https://nodejs.org/en/download/package-manager)

- NOTE: either `apt` or `rpm` should be all good for them.
  - I personally am moving from Fedora to Ubuntu.

### Windows

- `python -m pip install --user --upgrade pynvim`
- [fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim) dependencies
- [ctags](https://github.com/universal-ctags/ctags)
- [debugpy](https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#debugpy)
- Scoop for those binaries:
  - `scoop install git fd ripgrep nodejs lua51 luajit mingw msys2` (All of them are in official bucket as now.)
  - OpenDebugAD7.exe

## VSCode Configuration

To install the configuration:

- Move the json files from `vscode_config` to [VSCode settings directory](https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations)
  - Which I setup on my [vscodeConfig repo.](https://github.com/groutoutlook/vscodeConfig)
- Install following extensions:
  - [Whichkey (vspacecode.whichkey)](https://marketplace.visualstudio.com/items?itemName=vspacecode.whichkey)
    - Personally this made my experience not snappy as I thought so I turned it off.
  - [GitLens (eamodio.gitlens)](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
    - very optional though.
  - [Todo Tree (gruntfuggly.todo-tree)](https://marketplace.visualstudio.com/items?itemName=gruntfuggly.todo-tree)
    - Also optional.
