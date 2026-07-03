-- TREESITTER
return {
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
}
