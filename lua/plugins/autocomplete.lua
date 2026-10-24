return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.documentation = opts.completion.documentation or {}

      opts.completion.accept = opts.completion.accept or {}
      opts.completion.accept.auto_brackets = {
        enabled = false,
      }

      opts.completion.documentation.auto_show = false -- Desativa a janela de documentação automática

      opts.keymap = opts.keymap or {}
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
      opts.keymap["<CR>"] = { "select_and_accept", "fallback" }

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}

      for _, source in ipairs({ "lsp", "path" }) do
        if not vim.tbl_contains(opts.sources.default, source) then
          table.insert(opts.sources.default, source)
        end
      end

      opts.sources.default = vim.tbl_filter(function(source)
        return source ~= "snippets"
      end, opts.sources.default)
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.snippets = { enabled = false }

      opts.completion = opts.completion or {}
      opts.completion.ghost_text = opts.completion.ghost_text or {}
      opts.completion.ghost_text.enabled = false -- Desativa o ghost text no blink
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = { preselect = false, auto_insert = false }

      -- Some servers send snippets even when snippetSupport is false.
      -- Insert their text without starting a snippet session.
      opts.snippets = opts.snippets or {}
      opts.snippets.expand = function(body)
        local parsed = require("blink.cmp.sources.snippets.utils").safe_parse(body)
        assert(parsed, "Invalid completion snippet")
        vim.api.nvim_put(vim.split(tostring(parsed), "\n", { plain = true }), "c", false, true)
      end

      return opts
    end,
  },
}
