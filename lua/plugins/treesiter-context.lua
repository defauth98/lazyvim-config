return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      opts.enable = true -- Ensure the plugin stays active
      opts.max_lines = 5 -- Maximum lines the sticky window can span (0 = no limit)
      opts.min_window_height = 0 -- Minimum editor window height to enable context
      opts.line_numbers = true -- Match line numbers in the gutter
      opts.multiline_threshold = 20 -- Maximum number of lines to show for a single context
      opts.trim_scope = "outer" -- Discard outer or inner lines if max_lines is exceeded
      opts.mode = "cursor" -- Line used to calculate context ("cursor" or "topline")

      return opts
    end,
  },
}
