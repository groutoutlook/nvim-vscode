local M = {}

local diagnostics_active = true
local toggle_diagnostics = function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

M.keymaps = function ()
  vim.keymap.set("n", "<leader>zl", toggle_diagnostics, { desc = "Visual.diagnostics" })
end

M.setup = function ()
  local lsp_zero = require("lsp-zero")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

  lsp_zero.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps({
      buffer = bufnr,
      preserve_mappings = false,
      exclude = { "gs" },
    })
    vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr })
  end)

  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = {
      -- "typos_lsp",
      "clangd",
      "pyright",
      "lua_ls",
      "yamlls",
      "jsonls",
      "bashls",
      -- "markdown_oxide",
    },
  })

  require("mason-lspconfig").setup_handlers({
    -- default handler
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,

    -- clangd
    ["clangd"] = function()
      require("lspconfig").clangd.setup({
        -- on_attach = on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(),
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      })
    end,

    -- Lua
    ["lua_ls"] = function()
      require("lspconfig").lua_ls.setup({
        capabilities = cmp_nvim_lsp.default_capabilities(),
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT", -- (LuaJIT in the case of Neovim)
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })
    end,
  })

  -- Completion
  local cmp = require("cmp")
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
    }),
  })
end

local get_logo = function (name)
  local logo_dict = {
    ["lua_ls"] = "󰢱",
    ["GitHub Copilot"] = "",
    ["clangd"] = "󰙱",
    ["pyright"] = "",
  }
  local icon = logo_dict[name]
  if icon == nil then
      return name
  end

  return icon
end

local lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return "  "
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, get_logo(client.name))
  end
  return "  " .. table.concat(c, " ")
end

M.lualine = function ()
  local lualineX = require("lualine").get_config().sections.lualine_x or {}
  table.insert(lualineX, { lsp_clients })
  require("lualine").setup({ sections = { lualine_x = lualineX } })
end

return M