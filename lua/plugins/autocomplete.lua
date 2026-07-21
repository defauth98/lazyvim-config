return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.documentation = opts.completion.documentation or {}

      opts.completion.accept.auto_brackets = {
        enabled = false,
      }

      opts.completion.documentation.auto_show = false -- Desativa a janela de documentação automática

      opts.keymap = opts.keymap or {}
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
      opts.keymap["<CR>"] = { "accept", "fallback" }

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}

      for _, source in ipairs({ "lsp", "path", "snippets" }) do
        if not vim.tbl_contains(opts.sources.default, source) then
          table.insert(opts.sources.default, source)
        end
      end

      opts.completion = opts.completion or {}
      opts.completion.ghost_text = opts.completion.ghost_text or {}
      opts.completion.ghost_text.enabled = false -- Desativa o ghost text no blink

      return opts
    end,
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.lsp = opts.lsp or {}
      opts.lsp.signature = opts.lsp.signature or {}
      opts.lsp.signature.enabled = false -- Desativa a janela de documentação/parâmetros ao abrir parênteses

      return opts
    end,
  },
}
