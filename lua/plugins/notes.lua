local plugins = {
  'backdround/global-note.nvim',
  'epwalsh/obsidian.nvim',
  'iamcco/markdown-preview.nvim',
  'mpas/marp-nvim',
}

local conds = require('common.lazy').get_conds(plugins)
local NOTES_DIR = require('common.env').DIR_NOTES

return {
  -- Global note
  {
    'backdround/global-note.nvim',
    cond = conds['backdround/global-note.nvim'] or false,
    keys = {
      { '<leader>nn', desc = 'Notes.current' },
    },
    config = function()
      local global_note = require 'global-note'
      global_note.setup {
        filename = 'current.md',
        directory = NOTES_DIR,
        title = 'NOTE',
      }

      vim.keymap.set('n', '<leader>nn', global_note.toggle_note, { desc = 'Notes.current' })
    end,
  },
  -- Notes management
  {
    'epwalsh/obsidian.nvim',
    cond = conds['epwalsh/obsidian.nvim'] or false,
    version = '*',
    keys = {
      { '<leader>nj', ':ObsidianToday<cr>', desc = 'Notes.journal' },
    },
    -- event = {
    --   "BufReadPre " .. NOTES_DIR .. "/**.md",
    --   "BufNewFile " .. NOTES_DIR .. "/**.md",
    -- },
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "preservim/vim-markdown"
    },
    opts = {
      ui = {
        enable = false,
      },
      workspaces = {
        {
          name = 'notes',
          path = NOTES_DIR,
        },
      },
      templates = {
        folder = 'templates',
        date_format = '%Y.%m.%d.%a',
        time_format = '%H:%M',
      },
      daily_notes = {
        folder = 'journal',
        date_format = '%Y.%m.%d',
        template = 'daily.md',
      },
    },
  },
  -- Preview markdown files
  {
    'iamcco/markdown-preview.nvim',
    cond = conds['iamcco/markdown-preview.nvim'] or false,
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  -- Presentation
  {
    'mpas/marp-nvim',
    cond = conds['mpas/marp-nvim'] or false,
    cmd = { 'MarpToggle', 'MarpStatus' },
    config = function()
      vim.notify('Marp is enabled')
      require('marp').setup {
        port = 8080,
        wait_for_response_timeout = 30,
        wait_for_response_delay = 1,
      }
    end,
  },
}
