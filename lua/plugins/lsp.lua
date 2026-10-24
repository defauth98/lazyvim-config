return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        ["*"] = {
          capabilities = {
            textDocument = {
              completion = { completionItem = { snippetSupport = false } },
            },
          },
        },
        eslint = {
          settings = {
            validate = "on",
            run = "onType",
            workingDirectory = { mode = "auto" },
            codeAction = {
              disableRuleComment = { enable = true, location = "separateLine" },
              showDocumentation = { enable = true },
            },
          },
          keys = {
            {
              "<leader>ce",
              function()
                vim.lsp.buf.code_action({
                  context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
                  apply = true,
                })
              end,
              desc = "ESLint: Fix all",
            },
          },
        },
        vtsls = {
          settings = {
            complete_function_calls = false,
            typescript = { suggest = { completeFunctionCalls = false } },
            javascript = { suggest = { completeFunctionCalls = false } },
          },
        },
      },
    },
  },
}
