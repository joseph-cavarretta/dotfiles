-- NEOTREE
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local inputs = require("neo-tree.ui.inputs")

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

              -- guardrails: refuse obviously dangerous paths
              local function is_forbidden(p)
                local forbidden = {
                  "/",
                  vim.uv.os_homedir(),
                  vim.fn.getcwd(),
                  ".git",
                  ".svn",
                  "node_modules",
                }
                for _, f in ipairs(forbidden) do
                  if p == f or p:match("^" .. vim.pesc(f) .. "/") then
                    return true
                  end
                end
                return false
              end
              if is_forbidden(path) then
                vim.notify("Refusing to delete a protected path: " .. path, vim.log.levels.ERROR)
                return
              end

              -- choose a trash command per-OS
              local trash_cmd
              if vim.fn.has("macunix") == 1 and vim.fn.executable("trash") == 1 then
                trash_cmd = { "trash", path }           -- macOS: brew install trash
              elseif vim.fn.executable("trash-put") == 1 then
                trash_cmd = { "trash-put", path }       -- Linux: pacman -S trash-cli
              elseif vim.fn.executable("gio") == 1 then
                trash_cmd = { "gio", "trash", path }    -- Linux with gio
              end

              local function hard_delete()
                inputs.confirm("Permanently delete?\n" .. path, function(yes)
                  if not yes then return end
                  local ok = os.remove(path)
                  if not ok then
                    vim.fn.delete(path, "rf")           -- directory fallback
                  end
                  require("neo-tree.sources.manager").refresh(state.name)
                end)
              end

              inputs.confirm("Move ".. path .. " to Trash?", function(confirmed)
                if not confirmed then return end
                if trash_cmd then
                  local out = vim.fn.system(trash_cmd)  -- argv form, no shell
                  if vim.v.shell_error ~= 0 then
                    vim.notify("Trash failed:\n" .. out, vim.log.levels.WARN)
                    hard_delete()
                    return
                  end
                  require("neo-tree.sources.manager").refresh(state.name)
                else
                  vim.notify("No trash command found (install 'trash' on macOS or 'trash-cli'/'gio' on Linux).", vim.log.levels.WARN)
                  hard_delete()
                end
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
}
