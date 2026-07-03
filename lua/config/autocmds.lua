-- Disable spell checking by default, including filetypes where LazyVim enables it locally.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable_spell_by_default", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
