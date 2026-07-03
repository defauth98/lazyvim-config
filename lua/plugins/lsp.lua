local auto_format = vim.g.lazyvim_eslint_auto_format == nil or vim.g.lazyvim_eslint_auto_format

local function merge_server(opts, name, config)
  opts.servers = opts.servers or {}
  opts.servers[name] = vim.tbl_deep_extend("force", opts.servers[name] or {}, config)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = opts.inlay_hints or {}
      opts.inlay_hints.enabled = false

      opts.diagnostics = opts.diagnostics or {}
      opts.diagnostics.virtual_text = false -- Disables the text at the end of the line

      merge_server(opts, "bashls", {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, res, ...)
            local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ":t")
            if string.match(file_name, "^%.env") then
              return
            end
            return vim.lsp.diagnostic.on_publish_diagnostics(err, res, ...)
          end,
        },
      })

      merge_server(opts, "tsgo", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        settings = {
          typescript = {
            inlayHints = {
              enumMemberValues = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = {
                enabled = "literals",
                suppressWhenArgumentMatchesName = false,
              },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              variableTypes = { enabled = false },
            },
          },
        },
      })

      merge_server(opts, "eslint", {
        root_dir = function(fname)
          local util = require("lspconfig.util")

          return util.root_pattern(
            "package.json",
            "pnpm-lock.yaml",
            "yarn.lock",
            "package-lock.json",
            ".git"
          )(fname)
        end,
        settings = {
          packageManager = "pnpm",
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectory = { mode = "auto" },
          format = auto_format,
        },
      })

      opts.setup = opts.setup or {}
      opts.setup.eslint = function()
        if not auto_format then
          return
        end

        local formatter = LazyVim.lsp.formatter({
          name = "eslint: lsp",
          primary = false,
          priority = 200,
          filter = "eslint",
        })

        -- register the formatter with LazyVim
        LazyVim.format.register(formatter)
      end

      return opts
    end,
  },
}
