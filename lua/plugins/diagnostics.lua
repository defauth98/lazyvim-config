return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnósticos do projeto",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Diagnósticos do arquivo atual",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      require("insideee-dev.project-eslint").setup()
    end,
  },
}
