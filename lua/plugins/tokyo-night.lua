return {
  "folke/tokyonight.nvim",
  opts = function(_, opts)
    opts.style = "night"
    opts.transparent = true

    opts.styles = opts.styles or {}
    opts.styles.sidebars = "transparent"
    opts.styles.floats = "transparent"

    return opts
  end,
}
