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

-- Inline diagnostics are off (lua/plugins/lsp.lua), so show the line's messages in a float when the cursor rests.
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("diagnostic_float_on_hold", { clear = true }),
  callback = function()
    -- Don't cover hover docs, signature help or another float that is already open.
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" and config.focusable then
        return
      end
    end
    vim.diagnostic.open_float(nil, {
      focusable = false,
      scope = "line",
      border = "rounded",
      -- About 300px with the 15px JetBrains Mono used in the terminal (~9px per column).
      max_width = 34,
      wrap = true,
      prefix = function(_, index, total)
        return total > 1 and (index .. ". ") or "", "NormalFloat"
      end,
    })
  end,
})
