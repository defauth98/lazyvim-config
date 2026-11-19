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
          handlers = {
            ["$/progress"] = function(err, params, ctx, config)
              local client = vim.lsp.get_client_by_id(ctx.client_id)
              local value = params.value
              if client and type(value) == "table" and value.kind == "begin" then
                if type(value.title) == "string" and value.title:match("^Initializing '") then
                  -- vtsls has one initialization indicator, but nested tsconfigs can leave older tokens unfinished.
                  for token, title in pairs(client.progress.pending) do
                    if token ~= params.token and title:match("^Initializing '") then
                      vim.lsp.handlers["$/progress"](nil, { token = token, value = { kind = "end" } }, ctx, config)
                    end
                  end
                end
              end
              return vim.lsp.handlers["$/progress"](err, params, ctx, config)
            end,
          },
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
