return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = false },
      inlay_hints = { enabled = false },
      servers = {
        ["*"] = {
          capabilities = {
            textDocument = {
              completion = { completionItem = { snippetSupport = false } },
            },
          },
        },
        cssls = {
          capabilities = {
            textDocument = {
              -- O servidor CSS exige esta capacidade para fornecer completions.
              completion = { completionItem = { snippetSupport = true } },
            },
          },
        },
        vtsls = {
          settings = {
            complete_function_calls = false,
            vtsls = {
              experimental = {
                completion = { enableServerSideFuzzyMatch = true, entriesLimit = 200 },
              },
            },
            typescript = {
              suggest = { completeFunctionCalls = false },
              -- Project-wide diagnostics repeatedly scan large monorepos, including closed files.
              tsserver = {
                -- Large projects can exhaust the default 3 GiB heap and abort Node.
                maxTsServerMemory = 8192,
                experimental = { enableProjectDiagnostics = false },
              },
            },
            javascript = {
              suggest = { completeFunctionCalls = false },
              tsserver = { experimental = { enableProjectDiagnostics = false } },
            },
          },
        },
      },
    },
  },
}
