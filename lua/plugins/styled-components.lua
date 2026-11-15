local function enable_plugin(settings)
  settings.vtsls = settings.vtsls or {}
  settings.vtsls.tsserver = settings.vtsls.tsserver or {}
  local tsserver = settings.vtsls.tsserver
  tsserver.globalPlugins = tsserver.globalPlugins or {}
  for _, plugin in ipairs(tsserver.globalPlugins) do
    if plugin.name == "@styled/typescript-styled-plugin" then
      return false
    end
  end
  table.insert(tsserver.globalPlugins, {
    name = "@styled/typescript-styled-plugin",
    location = vim.fn.stdpath("data") .. "/styled-components/node_modules",
    enableForWorkspaceTypeScriptVersions = true,
  })
  return true
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "css", "styled" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local server = opts.servers.vtsls
      local has_dependency = require("insideee-dev.project-dependencies").has_dependency
      local default_before_init = server.before_init
      local default_on_attach = server.on_attach
      server.capabilities = vim.tbl_deep_extend("force", server.capabilities or {}, {
        textDocument = { completion = { completionItem = { snippetSupport = true } } },
      })
      server.settings = vim.tbl_deep_extend("force", server.settings or {}, {
        vtsls = { autoUseWorkspaceTsdk = true },
      })
      server.before_init = function(params, config)
        if default_before_init then
          default_before_init(params, config)
        end
        if has_dependency(config.root_dir, "styled-components", config.root_dir) then
          enable_plugin(config.settings)
        end
      end
      server.on_attach = function(client, bufnr)
        if default_on_attach then
          default_on_attach(client, bufnr)
        end
        -- A frontend package may be opened after the workspace server has already started.
        local directory = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
        if has_dependency(directory, "styled-components", client.config.root_dir) then
          if enable_plugin(client.settings) then
            client:notify("workspace/didChangeConfiguration", { settings = client.settings })
          end
        end
      end
    end,
  },
}
