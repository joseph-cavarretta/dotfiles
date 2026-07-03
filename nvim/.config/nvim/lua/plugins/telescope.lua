-- TELESCOPE
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
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
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        path_display = { "smart" },
        winblend = 0,

        -- ripgrep args for live_grep (includes dotfiles, excludes .git)
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob", "!.git/*",
        },

        preview = { filesize_limit = 1 },
      },

      pickers = {
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

    pcall(telescope.load_extension, "fzf")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files,  { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep,   { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers,     { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags,   { desc = "Help tags" })
    vim.keymap.set("n", "<leader>dd", builtin.diagnostics, { desc = "Diagnostics (buffer)" })
  end,
}
