-- Disable spell checking by default, including filetypes where LazyVim enables it locally.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable_spell_by_default", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Neovim 0.12 conceals whole Markdown lines (code fences) and links, which breaks line numbers and wrapping.
-- Obsidian notes enable conceal again through obsidian.nvim's enter_note callback.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_no_conceal", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
