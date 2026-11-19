local M = {}
local preview
local configured = false

local function append_chunk(line, text, highlight)
  local last = line[#line]
  if last and vim.deep_equal(last[2], highlight) then
    last[1] = last[1] .. text
  else
    line[#line + 1] = { text, highlight }
  end
end

local function wrap_lines(lines, width, gutter)
  local wrapped = {}
  for _, original in ipairs(lines) do
    local chunks = vim.deepcopy(original)
    -- GitSigns pads deleted lines to 300 cells; don't wrap that background padding.
    while #chunks > 0 do
      local chunk = chunks[#chunks]
      chunk[1] = chunk[1]:gsub("%s+$", "")
      if chunk[1] ~= "" then
        break
      end
      table.remove(chunks)
    end

    local line, text = {}, ""
    for _, chunk in ipairs(chunks) do
      for index = 0, vim.fn.strchars(chunk[1], true) - 1 do
        local char = vim.fn.strcharpart(chunk[1], index, 1, true)
        local column = vim.fn.strwidth(text)
        if char == "\t" then
          char = string.rep(" ", vim.fn.strdisplaywidth(char, column))
        end
        if vim.fn.strwidth(text .. char) > width and column > gutter then
          wrapped[#wrapped + 1] = line
          text = string.rep(" ", gutter)
          line = { { text, "Normal" } }
        end
        append_chunk(line, char, chunk[2])
        text = text .. char
      end
    end
    append_chunk(line, string.rep(" ", math.max(0, width - vim.fn.strwidth(text))), "GitSignsDeleteVirtLn")
    wrapped[#wrapped + 1] = line
  end
  return wrapped
end

local function refresh()
  if not preview then
    return
  end
  local state = preview
  if not vim.api.nvim_win_is_valid(state.win) or not vim.api.nvim_buf_is_valid(state.buf) then
    preview = nil
    return
  end
  local mark = vim.api.nvim_buf_get_extmark_by_id(state.buf, state.ns, state.id, { details = true })
  if #mark == 0 or vim.api.nvim_win_get_buf(state.win) ~= state.buf then
    preview = nil
    return
  end

  local width = vim.api.nvim_win_get_width(state.win)
  local gutter = math.min(vim.fn.getwininfo(state.win)[1].textoff, math.max(0, width - 2))
  local details = mark[3]
  vim.api.nvim_buf_set_extmark(state.buf, state.ns, mark[1], mark[2], {
    id = state.id,
    virt_lines = wrap_lines(state.lines, width, gutter),
    virt_lines_above = details.virt_lines_above,
    virt_lines_leftcol = true,
  })
end

function M.setup()
  if configured then
    return
  end
  configured = true

  -- Neovim doesn't wrap virt_lines. Adapt only GitSigns' inline renderer, keeping its highlights and cleanup.
  -- This internal entry point is available in the GitSigns revision pinned by lazy-lock.json.
  local renderer = require("gitsigns.deleted_preview")
  local place_lines = renderer.place_inline_preview_lines
  renderer.place_inline_preview_lines = function(buf, ns, hunk, staged, opts)
    local id = place_lines(buf, ns, hunk, staged, opts)
    local mark = vim.api.nvim_buf_get_extmark_by_id(buf, ns, id, { details = true })
    preview = {
      buf = buf,
      ns = ns,
      id = id,
      win = opts and opts.win or vim.api.nvim_get_current_win(),
      lines = mark[3].virt_lines,
    }
    refresh()
    return id
  end

  vim.api.nvim_create_autocmd("WinResized", {
    group = vim.api.nvim_create_augroup("gitsigns_inline_wrap", { clear = true }),
    callback = refresh,
    desc = "Recalcular quebra de linha do diff inline do GitSigns",
  })
end

return M
