local M = {}

M.setup = function()
  local lint = require 'lint'
  lint.linters_by_ft = {
    -- c = { "cppcheck" },
  }

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })
end

local lint_progress = function()
  local linters = require('lint').get_running()
  if #linters == 0 then
    return '  ' .. table.concat(linters, ', ')
  end
  return '  ' .. table.concat(linters, ', ')
end

M.lualine = function()
  local lualineX = require('lualine').get_config().sections.lualine_x or {}
  local index = #lualineX == 0 and 1 or #lualineX
  table.insert(lualineX, index, { lint_progress })

  require('lualine').setup { sections = { lualine_x = lualineX } }
end

return M
