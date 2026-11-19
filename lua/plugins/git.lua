return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        win = { width = 0.98, height = 0.95 },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>GitDiff<cr>", desc = "Git Diff" },
      { "<leader>gD", false },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      require("insideee-dev.gitsigns-wrap").setup()
      local on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        local result = on_attach and on_attach(buffer)
        -- O LazyVim cria estes atalhos a cada buffer anexado ao GitSigns.
        for _, key in ipairs({ "<leader>ghd", "<leader>ghD", "<leader>ghp", "<leader>gp" }) do
          pcall(vim.keymap.del, "n", key, { buffer = buffer })
        end
        vim.keymap.set("n", "<leader>hd", function()
          vim.wo.wrap = true
          require("gitsigns").preview_hunk_inline()
        end, { buffer = buffer, desc = "Diff inline no buffer" })
        vim.keymap.set("n", "<leader>hh", function()
          require("gitsigns").nav_hunk("next")
        end, { buffer = buffer, desc = "Próximo hunk" })
        vim.keymap.set("n", "<leader>hp", function()
          require("gitsigns").nav_hunk("prev")
        end, { buffer = buffer, desc = "Hunk anterior" })
        return result
      end
    end,
  },
}
