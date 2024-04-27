return {
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Tasks.run" },
      { "<leader>ot", "<cmd>OverseerToggle left<cr>", desc = "Tasks.toggle" },
    },
    config = function()
      require("overseer").setup({
        strategy = "toggleterm",
        dap = false,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "stevearc/overseer.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>ds", desc = "Dap.continue/start" },
      -- { "<leader>dr", "<cmd>lua require('dap').stop()<cr>", desc = "run w/o debug" },
      { "<leader>dx", "<cmd>lua require('dap').close()<cr>", desc = "Dap.stop" },
      { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Dap.pause" },
      { "<leader>dj", "<cmd>lua require('dap').step_into()<cr>", desc = "Dap.step_into" },
      { "<leader>dk", "<cmd>lua require('dap').step_out()<cr>", desc = "Dap.step_out" },
      { "<leader>dl", "<cmd>lua require('dap').step_over()<cr>", desc = "Dap.step_over" },
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Dap.breakpoint" },
      {
        "<leader>dK",
        "<cmd>lua require('dap.ui.variables').hover(function() vim.fn.expand('<cexpr>') end)<cr>",
        mode = "n",
        desc = "Dap.hover",
      },
      { "<leader>dK", "<cmd>lua require('dap.ui.variables').visual_hover()<cr>", mode = "v", desc = "Dap.hover" },
      { "<leader>d?", "<cmd>lua require('dap.ui.variables').scopes()<cr>", mode = "v", desc = "Dap.hover" },
      {
        "<leader>dB",
        "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
        desc = "Dap.breakpoint_with_message",
      },
    },
    config = function()
      local dap = require("dap")
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      require("dap.ext.vscode").load_launchjs()
      require("overseer").patch_dap(true)
      require("nvim-dap-virtual-text").setup()

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "@error", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "󰰍", texthl = "@error", linehl = "", numhl = "" })

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "C:\\Data\\Other\\cpptools-win64\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe",
        options = {
          detached = false,
        },
      }

      vim.g.dap_virtual_text = true

      -- Keymaps
      vim.keymap.set("n", "<leader>ds", function()
        if vim.fn.filereadable(".vscode/launch.json") then
          require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
        end
        require("dap").continue()
      end)

      vim.keymap.set({ "n", "v" }, "<leader>dt", function()
        require("dap.ui.widgets").preview()
      end)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>dd", "<cmd>lua require('dapui').toggle()<CR>", desc = "Dap.toggle_view" },
    },
    config = function()
      require("dapui").setup()
    end,
  },
}