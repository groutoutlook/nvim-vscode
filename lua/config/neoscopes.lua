local M = {}

M.keys = {
  { '<leader>ww', desc = 'select_scope' },
  { '<leader>wx', desc = 'close_scope' },
}

local global_scopes = function()
  local neoscopes = require 'neoscopes'
  neoscopes.add { name = 'notes', dirs = { require('common.env').DIR_NOTES } }
  neoscopes.add { name = 'nvim_config', dirs = { require('common.env').DIR_NVIM } }
end

local replace_telescope_keymaps = function()
  local neoscopes = require 'neoscopes'
  vim.keymap.set('n', '<leader>ff', function()
    require('telescope.builtin').find_files {
      prompt_prefix = '󱇳 > ',
      search_dirs = neoscopes.get_current_dirs(),
    }
  end, { desc = 'files(workspace)' })

  vim.keymap.set('n', '<leader>fA', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local basename = vim.fn.fnamemodify(bufname, ':t:r'):lower()
    require('telescope.builtin').find_files {
      prompt_prefix = '󱇳 > ',
      default_text = basename,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end, { desc = 'alternate(workspace)' })

  vim.keymap.set('n', '<leader>fl', function()
    require('telescope.builtin').live_grep {
      prompt_prefix = '󱇳 > ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end, { desc = 'live_grep_global(workspace)' })

  vim.keymap.set('n', '<leader>fL', function()
    require('telescope').extensions.live_grep_args.live_grep_args {
      prompt_prefix = '󱇳 > ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end, { desc = 'live_grep_global_with_args(workspace)' })

  vim.keymap.set('n', '<leader>?', function()
    require('telescope.builtin').grep_string {
      prompt_prefix = '󱇳 > ',
      search = vim.fn.input 'Search > ',
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end, { desc = 'global(workspace)' })

  vim.keymap.set('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    require('telescope.builtin').grep_string {
      prompt_prefix = '󱇳 > ',
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end, { desc = 'word(workspace)' })

  vim.keymap.set('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    require('telescope.builtin').grep_string {
      prompt_prefix = '󱇳 > ',
      search = word,
      search_dirs = neoscopes.get_current_dirs(),
      additional_args = { '--follow' },
    }
  end, { desc = 'whole_word(workspace)' })
end

local refresh_workspace = function()
  local neoscopes = require 'neoscopes'
  local current_scope = neoscopes.get_current_scope()
  if current_scope == nil then
    vim.notify '󱇳 No scope selected'
    require('config.telescope').keymaps()
  else
    local scope_name = neoscopes.get_current_scope().name
    vim.notify('Scope selected: 󱇳 ' .. scope_name)
    replace_telescope_keymaps()
    if _G.onSelectWorkspace ~= nil then
      _G.onSelectWorkspace(scope_name)
    end
  end
end

M.select_scope = function()
  local neoscopes = require 'neoscopes'
  neoscopes.setup {
    neoscopes_config_filename = _G.scope_config,
    on_scope_selected = refresh_workspace,
  }
  global_scopes()
  neoscopes.select()
end

M.keymaps = function()
  local neoscopes = require 'neoscopes'
  vim.keymap.set('n', '<leader>ww', M.select_scope, { desc = 'select_scope' })

  vim.keymap.set('n', '<leader>wx', function()
    neoscopes.clear()
    refresh_workspace()
  end, { desc = 'close_scope' })
end

local function lualine_status()
  local neoscopes = require 'neoscopes'
  local current_scope = neoscopes.get_current_scope()
  if current_scope == nil then
    return '󱇳 '
  end
  return '󱇳 ' .. neoscopes.get_current_scope().name
end

M.lualine = function()
  local lualineZ = require('lualine').get_config().tabline.lualine_z or {}
  table.insert(lualineZ, { lualine_status })

  require('lualine').setup { tabline = { lualine_z = lualineZ } }
end

M.config = function()
  M.keymaps()
  M.lualine()
end

-- M.config()

return M
