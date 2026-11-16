return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      -- Keep the tab row transparent like the rest of the Tokyo Night setup.
      opts.highlights = function(defaults)
        local highlights = vim.deepcopy(defaults.highlights)
        for _, group in pairs(highlights) do
          group.bg = "NONE"
        end
        return highlights
      end

      opts.options = opts.options or {}
      opts.options.mode = "tabs"
      opts.options.always_show_bufferline = true
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
      -- In tabs mode, name each tab after its file window, never after Neo-tree or other side panels.
      opts.options.custom_filter = function(buf)
        return vim.bo[buf].buftype == ""
      end
      -- Disambiguate index/styles files by showing their parent directory.
      opts.options.name_formatter = function(buffer)
        local stem = vim.fn.fnamemodify(buffer.name, ":r")
        if stem == "index" or stem == "styles" then
          return vim.fn.fnamemodify(buffer.path, ":h:t") .. "/" .. buffer.name
        end
        return buffer.name
      end
      opts.options.truncate_names = false
      opts.options.enforce_regular_tabs = false
      opts.options.max_prefix_length = math.huge

      for _, offset in ipairs(opts.options.offsets or {}) do
        if offset.filetype == "neo-tree" then
          offset.text = ""
        end
      end
    end,
  },
}
