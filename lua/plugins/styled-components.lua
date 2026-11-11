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
          capabilities = {
            textDocument = {
              completion = { completionItem = { snippetSupport = true } },
            },
          },
          settings = {
            vtsls = {
              autoUseWorkspaceTsdk = true,
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
