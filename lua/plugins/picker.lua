-- File pickers open the choice in a new tab, or focus the tab already showing it; an empty tab is reused.
local function open_in_tab(picker, item, action)
  local cmd = vim.api.nvim_win_call(picker.main, require("insideee-dev.utils").tab_has_file_window) and "tabdrop"
    or "drop"
  return Snacks.picker.actions.jump(picker, item, vim.tbl_extend("force", action or {}, { cmd = cmd }))
end

local file_sources = { "files", "git_files", "recent", "smart", "grep", "grep_word", "grep_buffers", "buffers" }

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.actions = opts.picker.actions or {}
      opts.picker.actions.open_in_tab = open_in_tab
      opts.picker.sources = opts.picker.sources or {}
      for _, source in ipairs(file_sources) do
        opts.picker.sources[source] = vim.tbl_extend("force", opts.picker.sources[source] or {}, {
          confirm = "open_in_tab",
        })
      end
    end,
  },
}
