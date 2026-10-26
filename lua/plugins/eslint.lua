return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local default_root_dir = vim.lsp.config.eslint.root_dir
      local kolab_root = vim.fn.expand("~/kolab/kolab-back-end")

      opts.servers.eslint.root_dir = function(bufnr, on_dir)
        -- This repository migrated to Biome but still contains orphaned ESLint configs.
        if vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }) == kolab_root then
          return
        end
        default_root_dir(bufnr, on_dir)
      end
    end,
  },
}
