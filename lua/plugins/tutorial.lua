-- Experimento baseado no tutorial Part 3; backup em ~/.local/state/nvim-config-backups/.
return {
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap.preset = "enter"
      opts.keymap["<C-y>"] = { "select_and_accept", "fallback" }
      opts.appearance = opts.appearance or {}
      opts.appearance.nerd_font_variant = "mono"
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets" }
      if not vim.tbl_contains(opts.sources.default, "buffer") then table.insert(opts.sources.default, "buffer") end
    end,
  },
  {
    "nvim-mini/mini.bracketed",
    event = "BufReadPost",
    opts = {
      file = { suffix = "" }, window = { suffix = "" },
      quickfix = { suffix = "" }, yank = { suffix = "" },
      treesitter = { suffix = "n" },
    },
  },
  { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
  {
    "folke/snacks.nvim",
    opts = { dashboard = { enabled = true, preset = { header = "LazyVim • Developer Workflows" } } },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    opts = { plugins = { gitsigns = true, tmux = true } },
  },
  { "akinsho/bufferline.nvim", opts = { options = {
    mode = "buffers", always_show_bufferline = true,
    show_buffer_close_icons = false, show_close_icon = false,
    name_formatter = function(buffer)
      local stem = vim.fn.fnamemodify(buffer.name, ":r")
      if stem == "index" or stem == "styles" then
        return vim.fn.fnamemodify(buffer.path, ":h:t") .. "/" .. buffer.name
      end
      return buffer.name
    end,
  } } },
}
