vim.g.lazyvim_ts_lsp = "tsgo"
vim.diagnostic.config({
  virtual_text = false,
})

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
  {
    "folke/noice.nvim",
    enabled = false,
  },
}
