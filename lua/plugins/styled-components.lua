return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "css", "styled" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "@styled/typescript-styled-plugin",
                    location = vim.fn.stdpath("data") .. "/styled-components/node_modules",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
          },
        },
      },
    },
  },
}
