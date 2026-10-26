return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
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
