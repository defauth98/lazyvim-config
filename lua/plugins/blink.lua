return {
  "saghen/blink.cmp",
  opts = function(_, opts)
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
}
