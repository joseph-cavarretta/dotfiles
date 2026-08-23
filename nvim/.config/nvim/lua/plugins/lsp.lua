-- LSP: mason (installer) + mason-lspconfig (bridge) + nvim-lspconfig (server defs)
-- Single source of truth for the server list, used by both mason-lspconfig and vim.lsp.enable.
local servers = {
  "lua_ls", "pyright", "ruff", "sqlls", "bashls",
  "yamlls", "dockerls", "ts_ls", "terraformls", "clangd",
}

return {
  -- MASON: installer UI
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- MASON-LSPCONFIG: ensures mason-installed servers are available to vim.lsp
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })
    end,
  },

  -- LSPCONFIG: provides server definitions; we configure via vim.lsp.config (nvim 0.11+)
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
        underline = false,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- keymaps on attach; ruff only handles linting so skip keymaps and disable hover
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
            return
          end
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition,        "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration,       "Go to declaration")
          map("n", "gr", vim.lsp.buf.references,        "List references")
          map("n", "gi", vim.lsp.buf.implementation,    "Go to implementation")
          map("n", "K",  vim.lsp.buf.hover,             "Hover docs")
          map("n", "<leader>rn", vim.lsp.buf.rename,    "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>fd", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })

      vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
              disable = { "undefined-global", "missing-fields" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            keyOrdering = false,
            validate = true,
            format = { enable = true },
          },
        },
      })

      vim.lsp.enable(servers)
    end,
  },
}
