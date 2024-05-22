local plugins = {
  'smoka7/hop.nvim',
  'kylechui/nvim-surround',
  'chentoast/marks.nvim',
  'gregorias/coerce.nvim',
  'monaqa/dial.nvim',
  -- Macros
  'chrisgrieser/nvim-recorder',
  'AllenDang/nvim-expand-expr',
}

local conds = require('common.lazy').get_conds(plugins)

return {
  {
    'smoka7/hop.nvim',
    cond = conds['smoka7/hop.nvim'] or false,
    keys = {
      { '<leader><space>', '<cmd>HopChar2<cr>', desc = 'hop' },
    },
    opts = {
      multi_windows = true,
      uppercase_labels = true,
      jump_on_sole_occurrence = false,
    },
  },
  {
    'kylechui/nvim-surround',
    cond = conds['kylechui/nvim-surround'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    version = '*',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'chentoast/marks.nvim',
    cond = conds['chentoast/marks.nvim'] or false,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  {
    'gregorias/coerce.nvim',
    cond = conds['gregorias/coerce.nvim'] or false,
    keys = {
      { 'cr', desc = 'coerce' },
    },
    tag = 'v1.0',
    opts = {},
  },
  {
    'monaqa/dial.nvim',
    cond = conds['monaqa/dial.nvim'] or false,
    keys = {
      { '<leader>i', "<cmd>lua require('dial.map').manipulate('increment', 'normal')<cr>", desc = 'increment' },
      { '<leader>I', "<cmd>lua require('dial.map').manipulate('decrement', 'normal')<cr>", desc = 'decrement' },
    },
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver,
          augend.date.alias['%Y/%m/%d'],
        },
      }
    end,
  },
  -- Macros
  {
    'chrisgrieser/nvim-recorder',
    cond = conds['chrisgrieser/nvim-recorder'] or false,
    keys = {
      { 'q', desc = 'macro_record' },
      { 'Q', desc = 'macro_play' },
    },
    config = function()
      local config = require 'config.recorder'
      config.setup()
      if not vim.g.vscode then
        config.lualine()
      end
    end,
  },
  {
    'AllenDang/nvim-expand-expr',
    cond = conds['AllenDang/nvim-expand-expr'] or false,
    keys = {
      {
        '<leader>oq',
        function()
          require('expand_expr').expand()
        end,
        desc = 'Tasks.inline_macro',
      },
    },
  },
}
