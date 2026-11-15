return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local default_root_dir = vim.lsp.config.eslint.root_dir
      local kolab_root = vim.fn.expand("~/kolab/kolab-back-end")
      local kolab_git_dir = vim.uv.fs_realpath(kolab_root .. "/.git")
      local kolab_roots = { [kolab_root] = true }

      opts.servers.eslint.settings.format = false

      opts.servers.eslint.root_dir = function(bufnr, on_dir)
        -- This repository migrated to Biome but still contains orphaned ESLint configs.
        local biome_root = vim.fs.root(bufnr, { "biome.json", "biome.jsonc" })
        if biome_root then
          if kolab_roots[biome_root] == nil then
            -- Linked worktrees share a Git directory, regardless of their location or name.
            local result = vim
              .system({ "git", "-C", biome_root, "rev-parse", "--path-format=absolute", "--git-common-dir" }, {
                text = true,
              })
              :wait(1000)
            kolab_roots[biome_root] = result.code == 0 and vim.trim(result.stdout) == kolab_git_dir
          end
          if kolab_roots[biome_root] then
            return
          end
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
