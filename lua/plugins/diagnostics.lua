return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Diagnósticos do arquivo atual",
      },
    },
  },
}
