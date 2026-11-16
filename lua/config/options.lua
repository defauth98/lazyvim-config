vim.opt.mouse = ""
vim.opt.swapfile = false
vim.opt.wrap = true
vim.g.lazyvim_mini_snippets_in_completion = false
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_ts_lsp = "vtsls"
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
