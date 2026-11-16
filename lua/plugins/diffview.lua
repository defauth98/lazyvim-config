return {
  "dlyongemallo/diffview-plus.nvim",
  version = "*",
  lazy = true,
  cmd = {
    "DiffviewOpen",
    "DiffviewToggle",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewDiffFiles",
    "DiffviewLog",
  },
  init = function()
    require("insideee-dev.git-diff").setup()
  end,
  opts = function()
    local actions = require("diffview.actions")
    local close = { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Fechar o Diffview" } }
    local hunk_keys = {
      { "n", "<leader>hh", "]c", { remap = true, desc = "Próximo hunk" } },
      { "n", "<leader>hp", "[c", { remap = true, desc = "Hunk anterior" } },
    }
    return {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        cycle_layouts = {
          default = { "diff2_horizontal", "diff1_inline" },
        },
      },
      file_panel = {
        listing_style = "list",
      },
      keymaps = {
        view = vim.list_extend({ close }, hunk_keys),
        file_panel = {
          close,
          { "n", "t", actions.cycle_layout, { desc = "Alternar lado a lado / inline" } },
        },
        file_history_panel = { close },
      },
    }
  end,
}
