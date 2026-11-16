return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "dlyongemallo/diffview-plus.nvim",
    "m00qek/baleia.nvim",
    "folke/snacks.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Git status (Neogit)" },
  },
}
