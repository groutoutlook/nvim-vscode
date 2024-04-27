return {
  -- Looks
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()

      require("vscode").setup({
        italic_comments = true,
        group_overrides = {
          -- TODO: Add more overrides
          -- https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/theme.lua
          -- https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/colors.lua
          DiagnosticError = { fg = c.vscRed, bg = c.vscPopupHighlightGray },
          DiagnosticInfo = { fg = c.vscBlue, bg = c.vscPopupHighlightGray },
          DiagnosticHint = { fg = c.vscBlue, bg = c.vscPopupHighlightGray },
        },
      })
      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    priority = 900,
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        change_to_vcs_root = true,
        config = {
          week_header = {
            enable = true,
          },
          project = { enable = false },
          mru = { cwd_only = true },
          shortcut = {
            {
              desc = "󱇳 Workspace",
              group = "Number",
              action = "lua require('neoscopes').select()",
              key = "w",
            },
            {
              desc = " Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = "󰊳 Update",
              group = "@property",
              action = "Lazy update",
              key = "u",
            },
          },
          footer = {},
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function scope()
        local status, neoscopes = pcall(require, "neoscopes")
        if not status then
          return "󱇳 No scope selected"
        end

        local current_scope = neoscopes.get_current_scope()
        if current_scope == nil then
          return "󱇳 No scope selected"
        end

        return "󱇳 " .. neoscopes.get_current_scope().name
      end

      require("lualine").setup({
        extensions = { "overseer", "nvim-dap-ui" },
        options = {
          theme = "vscode",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          ignore_focus = { "OverseerList", "neo-tree", "vista" },
        },
        sections = {
          lualine_a = {
            "mode",
            "selectioncount",
          },
          lualine_b = {
            "branch",
            "diff",
          },
          lualine_c = {
            { "filename", path = 1 },
            "harpoon2",
          },
          lualine_x = {
            "overseer",
            "diagnostics",
            scope,
          },
          lualine_y = {
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_z = {
            "progress",
            "location",
          },
        },
        winbar = {
          lualine_c = {
            {
              "buffers",
              mode = 4,
              symbols = {
                alternate_file = "",
              },
            },
          },
        },
      })
    end,
  },
  {
    "letieu/harpoon-lualine",
    event = { "VeryLazy" },
    dependencies = {
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      },
    },
  },
  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "HiPhish/rainbow-delimiters.nvim" },
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({
        scope = { highlight = highlight },
        exclude = {
          filetypes = { "dashboard" },
        },
      })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "VonHeikemen/lsp-zero.nvim",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
      })
      vim.keymap.set("n", "<leader>znl", function()
        require("noice").cmd("last")
      end, { desc = "Visual.Notifications.last" })
      vim.keymap.set("n", "<leader>znh", function()
        require("noice").cmd("history")
      end, { desc = "Visual.Notifications.history" })
      vim.keymap.set("n", "<leader>znx", function()
        require("noice").cmd("disable")
      end, { desc = "Visual.Notifications.disable" })
    end,
  },
}
