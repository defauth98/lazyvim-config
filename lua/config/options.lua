vim.g.lazyvim_mini_snippets_in_completion = false
vim.g.lazyvim_prettier_needs_config = true
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

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
