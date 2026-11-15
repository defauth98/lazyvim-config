return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local server = opts.servers.tailwindcss
      local default_root_dir = server.root_dir or vim.lsp.config.tailwindcss.root_dir
      server.settings = vim.tbl_deep_extend("force", server.settings or {}, {
        tailwindCSS = { classFunctions = { "cn", "clsx", "cva", "twMerge", "tw", "tw\\.[a-z-]+" } },
      })
      server.root_dir = function(bufnr, on_dir)
        default_root_dir(bufnr, function(root)
          local directory = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
          local has_dependency = require("insideee-dev.project-dependencies").has_dependency
          local config = vim.fs.find({
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "tailwind.config.cts",
            "tailwind.config.mts",
          }, { path = directory, upward = true, stop = vim.fs.dirname(root) })[1]
          local explicit_config = (server.settings.tailwindCSS.experimental or {}).configFile
          if config or explicit_config or has_dependency(directory, "tailwindcss", root) then
            on_dir(root)
          end
        end)
      end
    end,
  },
}
