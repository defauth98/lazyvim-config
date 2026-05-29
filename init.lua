require("config.lazy")
require("neo-tree").setup({
  source_selector = {
    winbar = true,
    statusline = false,
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_ignored = false,
      hide_hidden = true,
    },
  },
})
