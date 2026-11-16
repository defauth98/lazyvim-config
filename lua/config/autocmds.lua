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
local diagnostic_float_width = 50 -- About 450px with the 15px JetBrains Mono used in the terminal (~9px per column).

-- open_float clips long messages to the space above or below the cursor. Widen the float until the whole message
-- fits on one side, or cover the editor height when it doesn't fit even at full width.
local function fit_diagnostic_float(win)
  local usable_rows = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus > 0 and 1 or 0)
  local win_row, win_col = unpack(vim.fn.win_screenpos(0))
  local cursor_row = win_row + vim.fn.winline() - 1
  local rows_above = cursor_row - 1 - 2 -- minus the border
  local rows_below = usable_rows - cursor_row - 2
  local max_width = vim.o.columns - 4
  local width = vim.api.nvim_win_get_config(win).width
  local function text_height()
    vim.api.nvim_win_set_config(win, { width = width })
    return vim.api.nvim_win_text_height(win, {}).all
  end

  local height = text_height()
  while height > math.max(rows_above, rows_below) and width < max_width do
    width = math.min(width + 10, max_width)
    height = text_height()
  end

  local col = math.max(0, math.min(win_col + vim.fn.wincol() - 2, vim.o.columns - width - 2))
  local config = { relative = "editor", width = width, col = col, anchor = "NW" }
  if height <= rows_below then
    config.row, config.height = cursor_row, height
  elseif height <= rows_above then
    config.row, config.height, config.anchor = cursor_row - 1, height, "SW"
  else
    config.row, config.height = 0, math.min(height, usable_rows - 2)
  end
  vim.api.nvim_win_set_config(win, config)
end

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
    local _, win = vim.diagnostic.open_float(nil, {
      focusable = false,
      scope = "line",
      border = "rounded",
      max_width = diagnostic_float_width,
      wrap = true,
      prefix = function(_, index, total)
        return total > 1 and (index .. ". ") or "", "NormalFloat"
      end,
    })
    if win then
      fit_diagnostic_float(win)
    end
  end,
})
