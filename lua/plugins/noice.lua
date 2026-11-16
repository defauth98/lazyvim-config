return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      table.insert(opts.routes, 1, {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            -- Noice evaluates filter keys in arbitrary order, including cond before event/kind.
            if message.event ~= "lsp" or message.kind ~= "progress" or not message.opts.progress then
              return false
            end

            -- Noice shares opts between progress updates and the completion message.
            local progress = message.opts
            if progress.progress.kind == "end" then
              return not progress.long_running_visible
            end

            local now = vim.uv.hrtime()
            progress.started_at = progress.started_at or now
            if now - progress.started_at >= 10 * 1e9 then
              progress.long_running_visible = true
            end
            return not progress.long_running_visible
          end,
        },
        opts = { skip = true },
      })
    end,
  },
}
