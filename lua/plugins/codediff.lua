return {
  "esmuellert/codediff.nvim",
  lazy = true,
  cmd = "CodeDiff",
  init = function()
    -- O CodeDiff ativa scrollbind nos dois painéis; sincronize ambos os eixos.
    vim.opt.scrollopt:append({ "ver", "hor", "jump" })
    require("insideee-dev.git-diff").setup()
  end,
  opts = {
    diff = { layout = "inline" },
    keymaps = {
      view = {
        next_hunk = { "]c", "<leader>hh" },
        prev_hunk = { "[c", "<leader>hp" },
      },
    },
    explorer = {
      view_mode = "list",
      auto_refresh = true,
    },
  },
}
