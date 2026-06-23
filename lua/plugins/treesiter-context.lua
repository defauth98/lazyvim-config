return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true, -- Ensure the plugin stays active
      max_lines = 5, -- Maximum lines the sticky window can span (0 = no limit)
      min_window_height = 0, -- Minimum editor window height to enable context
      line_numbers = true, -- Match line numbers in the gutter
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Discard outer or inner lines if max_lines is exceeded
      mode = "cursor", -- Line used to calculate context ("cursor" or "topline")
    },
  },
}
