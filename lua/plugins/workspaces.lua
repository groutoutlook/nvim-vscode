local plugins = {
  "smartpde/neoscopes",
  "stevearc/resession.nvim",
  "aymericbeaumet/vim-symlink",
}

local cond_table = require("common.lazy").get_cond_table(plugins)
local get_cond = require("common.lazy").get_cond

return {
  {
    "aymericbeaumet/vim-symlink",
    cond = get_cond("aymericbeaumet/vim-symlink", cond_table),
    dependencies = { "moll/vim-bbye" },
    event = "VeryLazy",
  },
  {
    "smartpde/neoscopes",
    cond = get_cond("smartpde/neoscopes", cond_table),
    keys = {
      { "<leader>ww", desc = "Find.workspace" },
      { "<leader>wx", desc = "Workspace.close" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local neoscopes = require("neoscopes")
      local neoscopes_keymaps = function()
        vim.keymap.set("n", "<leader>ff", function()
          require("telescope.builtin").find_files({
            prompt_prefix = "󱇳 > ",
            search_dirs = neoscopes.get_current_dirs(),
          })
        end, { desc = "Find.files(workspace)" })
        -- remapping fa, f/, fgg not needed

        vim.keymap.set("n", "<leader>fg", function()
          require("telescope.builtin").live_grep({
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.Live_grep.global(workspace)" })

        vim.keymap.set("n", "<leader>f?", function()
          require("telescope.builtin").grep_string({
            prompt_prefix = "󱇳 > ",
            search = vim.fn.input("Search > "),
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.Search.global(workspace)" })

        vim.keymap.set("n", "<leader>fw", function()
          local word = vim.fn.expand("<cword>")
          require("telescope.builtin").grep_string({
            search = word,
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.word(workspace)" })

        vim.keymap.set("n", "<leader>fW", function()
          local word = vim.fn.expand("<cWORD>")
          require("telescope.builtin").grep_string({
            search = word,
            search_dirs = neoscopes.get_current_dirs(),
            additional_args = { "--follow" },
          })
        end, { desc = "Find.whole_word(workspace)" })
      end

      -- Remap Telescope
      local refresh_workspace = function()
        local current_scope = neoscopes.get_current_scope()
        if current_scope == nil then
          require("notify")("󱇳 No scope selected")
          _G.Telescope_keymaps()
        else
          require("notify")("Scope selected: 󱇳 " .. neoscopes.get_current_scope().name)
          neoscopes_keymaps()
        end
      end

      neoscopes.setup({ on_scope_selected = refresh_workspace })

      vim.keymap.set("n", "<leader>ww", function()
        neoscopes.setup({ on_scope_selected = refresh_workspace })
        neoscopes.select()
      end)

      vim.keymap.set("n", "<leader>wx", function()
        neoscopes.clear()
        refresh_workspace()
      end)
    end,
  },
  {
    "stevearc/resession.nvim",
    cond = get_cond("stevearc/resession.nvim", cond_table),
    keys = {
      { "<leader>ws", desc = "Workspace.session_save" },
      { "<leader>wl", desc = "Workspace.session_load" },
      { "<leader>wS", "<cmd>lua require('resession').save()<cr>", desc = "Workspace.manual_session_save" },
      { "<leader>wL", "<cmd>lua require('resession').load()<cr>", desc = "Workspace.manual_session_load" },
      { "<leader>wd", "<cmd>lua require('resession').delete()<cr>", desc = "Workspace.session_delete" },
    },

    config = function()
      local recession = require("resession")
      recession.setup({})

      local workspace_session = function(action)
        local status, neoscopes = pcall(require, "neoscopes")
        if status then
          local current_scope = neoscopes.get_current_scope()
          if current_scope ~= nil then
            action(current_scope.name)
            require("notify")("Session: " .. current_scope.name)
          else
            action("workspace")
            require("notify")("Session: workspace")
          end
        else
          action("workspace")
          require("notify")("Session: workspace")
        end
      end

      vim.keymap.set("n", "<leader>ws", function()
        workspace_session(recession.save)
      end)

      vim.keymap.set("n", "<leader>wl", function()
        workspace_session(recession.load)
      end)
    end,
  },
}
