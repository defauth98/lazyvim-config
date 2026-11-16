return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.mode = "buffers"
      opts.options.always_show_bufferline = true
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
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
