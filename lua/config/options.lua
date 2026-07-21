vim.g.lazyvim_ts_lsp = "tsgo"
vim.diagnostic.config({
  virtual_text = false,
})

vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
}

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
