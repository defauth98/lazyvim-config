return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local default_root_dir = vim.lsp.config.eslint.root_dir
      local kolab_root = vim.fn.expand("~/kolab/kolab-back-end")

      opts.servers.eslint.settings.format = false

      opts.servers.eslint.root_dir = function(bufnr, on_dir)
        -- This repository migrated to Biome but still contains orphaned ESLint configs.
        if vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }) == kolab_root then
          return
        end
        default_root_dir(bufnr, on_dir)
      end

      opts.setup = opts.setup or {}
      opts.setup.eslint = function()
        if vim.g.lazyvim_eslint_auto_format == false then
          return
        end

        LazyVim.format.register({
          name = "eslint: fix all",
          primary = false,
          -- Apply ESLint fixes after Conform/Prettier.
          priority = 50,
          sources = function(bufnr)
            return vim.tbl_map(function(client)
              return client.name
            end, vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" }))
          end,
          format = function(bufnr)
            -- Wait for all fixes before writing the buffer to disk.
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })) do
              local result, err = client:request_sync("workspace/executeCommand", {
                command = "eslint.applyAllFixes",
                arguments = {
                  { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] },
                },
              }, 3000, bufnr)
              if not result or result.err then
                error("ESLint fix all failed: " .. vim.inspect(err or (result and result.err)))
              end
            end
          end,
        })
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local prettier = opts.formatters.prettier
      local default_condition = prettier.condition

      prettier.condition = function(self, ctx)
        -- ESLint recommended rules do not provide general code formatting.
        return default_condition(self, ctx) or #vim.lsp.get_clients({ bufnr = ctx.buf, name = "eslint" }) > 0
      end
    end,
  },
}
