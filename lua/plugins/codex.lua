return {
  {
    "eskalVAR/codex.nvim",
    lazy = true,
    cmd = { "Codex", "CodexToggle", "CodexSend", "CodexAttachFile", "CodexContext", "CodexInterrupt" },
    keys = {
      { "<leader>cc", function() require("codex").toggle() end, mode = "n", desc = "Toggle Codex popup" },
    },
    opts = {
      width = 0.48,
      personality = "pragmatic",
      toggle_key = "<leader>cc",
      quit_key = "<C-q>",
      send_key = "<CR>",
      attach_file_key = "<C-f>",
      interrupt_key = "<C-c>",
    },
    config = function(_, opts)
      require("codex").setup(opts)
      -- Keep Space immediate while typing; Codex stays available in normal mode.
      vim.keymap.del("i", opts.toggle_key)
    end,
  },
}
