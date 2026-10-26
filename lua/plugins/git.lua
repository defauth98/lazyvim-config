return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        win = { width = 0.98, height = 0.95 },
      },
    },
    keys = {
      { "<leader>gd", false },
      { "<leader>gD", false },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        local result = on_attach and on_attach(buffer)
        -- O LazyVim cria estes atalhos a cada buffer anexado ao GitSigns.
        for _, key in ipairs({ "<leader>ghd", "<leader>ghD" }) do
          pcall(vim.keymap.del, "n", key, { buffer = buffer })
        end
        return result
      end
    end,
  },
}
