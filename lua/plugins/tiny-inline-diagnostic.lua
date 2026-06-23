return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000, -- load early
    config = function()
      require("tiny-inline-diagnostic").setup()
      -- Turn off default virtual text to prevent overlapping text
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
}
