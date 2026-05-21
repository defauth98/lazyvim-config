vim.g.lazyvim_eslint_auto_format = true
vim.g.lazyvim_prettier_needs_config = false
vim.g.lazyvim_ts_lsp = "tsgo"

return {
  { import = "lazyvim.plugins.extras.test.core" },
  { import = "lazyvim.plugins.extras.ui.mini-starter" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      enabled = false,
    },
  },
  {
    "folke/noice.nvim",
    enabled = false,
  },
}
