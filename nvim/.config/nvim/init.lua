-- * -------------------------------------------------------
-- BOOTSTRAP LAZY.NVIM

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- * ------------------------------------------------------
-- MAPPINGS & OPTS

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- tabs
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- highlight at column 80
vim.opt.colorcolumn = "80"

-- clipboard enable
vim.opt.clipboard = "unnamedplus"

-- line numbers and left padding
vim.opt.number = true
--vim.opt.statuscolumn = "%{v:lnum}"


-- * ------------------------------------------------------
-- PLUGINS

local plugins = {
  -- ATOM ONE DARK
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "dark" })
      require("onedark").load()
    end,
  },

  -- LUALINE
  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons
  config = function()
    require("lualine").setup({
      options = {
        theme = "onedark", -- match colorscheme
        section_separators = { left = " ", right = " " },
        component_separators = { left = " ", right = " " },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
  },

  -- TELESCOPE
  {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8", -- or branch = "0.1.x"
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function() return vim.fn.executable("make") == 1 end,
    },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        -- faster path display & fewer redraws
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        path_display = { "smart" },
        winblend = 0,

        -- search file contents by pattern using ripgrep (rg)
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",          -- search dotfiles
          "--glob", "!.git/*", -- but not .git
        },

        preview = { filesize_limit = 1 }, -- MB
      },

      pickers = {
        -- finds files by pattern using fd
        find_files = {
          previewer = true,
          layout_strategy = "horizontal",
          find_command = {
            "fd",
            "--type", "f",
            "--exclude", ".git",
            "--strip-cwd-prefix",
            "--hidden"
          },
          follow = true,
        },

        buffers = {
          sort_mru = true,
          ignore_current_buffer = false,
          previewer = true,
          show_all_buffers = true,
          mappings = {
            i = { ["<C-d>"] = "delete_buffer" },
            n = { ["dd"] = "delete_buffer" },
          },
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- load fzf extension if installed
    pcall(telescope.load_extension, "fzf")

    -- keymaps
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })
    vim.keymap.set("n", "<leader>dd", builtin.diagnostics, { desc = "Diagnostics (buffer)" })
    end,
  },

  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",   -- auto update parsers
    config = function()
      require("nvim-treesitter.configs").setup({
        -- languages to install (or "all")
        ensure_installed = {
          "bash", "c", "csv", "dockerfile", "go", "graphql", "html",
          "javascript", "json", "lua", "make", "markdown", "markdown_inline",
          "python", "regex", "sql", "terraform", "toml", "typescript",
          "vim", "yaml",
        },

        sync_install = false,  -- install languages asynchronously
        auto_install = true,   -- auto install missing parsers

        highlight = {
          enable = true,              -- enable highlighting
          additional_vim_regex_highlighting = false, -- disable old regex hl
        },

        indent = { enable = true },   -- smarter indentation
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end,
  },

  -- NEOTREE
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local inputs = require("neo-tree.ui.inputs")
      --local events = require("neo-tree.events")

      require("neo-tree").setup({
        filesystem = {
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_default",
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          window = {
            width = 30,
            mappings = {
              -- override "d" option to move files to trash with confirmation
              ["d"] = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()

                inputs.confirm("Move ".. path .. " to Trash?", function(confirmed)
                  if not confirmed then return end
                  -- requires macos trash cli installed (brew install trash)
                  vim.fn.system({ "trash", path })
                  require("neo-tree.sources.manager").refresh(state.name)
                end)
              end,
            },
          },
        },
      })

      -- keymaps
      vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem<CR>", { desc = "Toggle Neo-tree" })
      vim.keymap.set("n", "<leader>o", ":Neotree focus filesystem<CR>", { desc = "Focus Neo-tree" })
    end,
  },

  -- MASON: installer UI
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- MASON-LSPCONFIG: bridge between mason + lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "pyright",      -- Python
          "ruff",         -- Python linting/fixes (optional, very fast)
          "sqlls",        -- SQL
          "bashls",       -- Bash
          "yamlls",       -- YAML (great for K8s manifests)
          "dockerls",     -- Dockerfile
          "ts_ls",        -- TypeScript / JavaScript
          "terraformls",  -- Terraform
          "clangd",       -- C
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSPCONFIG: the actual LSP client
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- generic on_attach for keymaps
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition,        "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration,       "Go to declaration")
        map("n", "gr", vim.lsp.buf.references,        "List references")
        map("n", "gi", vim.lsp.buf.implementation,    "Go to implementation")
        map("n", "K",  vim.lsp.buf.hover,             "Hover docs")
        map("n", "<leader>rn", vim.lsp.buf.rename,    "Rename symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action,"Code action")
        map("n", "<leader>fd", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
        map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      --Lua
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT", -- Neovim uses LuaJIT
            },
            diagnostics = {
              globals = { "vim" }, -- don’t warn about “undefined global vim”
              disable = {
                "undefined-global",
                "missing-fields",
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true), -- pull in Neovim runtime files
              checkThirdParty = false, -- don’t prompt about external libraries
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })


      -- Python
      lspconfig.pyright.setup({ on_attach = on_attach, capabilities = capabilities })
      lspconfig.ruff.setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.hoverProvider = false
          on_attach(client, bufnr)
        end,
        capabilities = capabilities,
      })

      -- SQL
      lspconfig.sqlls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- Bash
      lspconfig.bashls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- YAML
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            keyOrdering = false,
            validate = true,
            format = { enable = true },
          },
        },
      })

      -- Docker
      lspconfig.dockerls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- TypeScript
      lspconfig.ts_ls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- Terraform
      lspconfig.terraformls.setup({ on_attach = on_attach, capabilities = capabilities })

      -- C / C++
      lspconfig.clangd.setup({ on_attach = on_attach, capabilities = capabilities })

    end,
  },

-- close plugins
}

local opts = {}


-- * ------------------------------------------------------
-- SETUP

require("lazy").setup(plugins, opts)


