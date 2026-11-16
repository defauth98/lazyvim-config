return {
  {
    "nvim-mini/mini.bracketed",
    event = "BufReadPost",
    opts = {
      file = { suffix = "" },
      window = { suffix = "" },
      quickfix = { suffix = "" },
      yank = { suffix = "" },
      treesitter = { suffix = "n" },
    },
  },
  { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    opts = { plugins = { gitsigns = true, tmux = true } },
  },
  {
    "folke/snacks.nvim",
    opts = { dashboard = { enabled = true, preset = { header = "LazyVim • Developer Workflows" } } },
  },
}
