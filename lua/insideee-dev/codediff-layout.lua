local M = {}

local text_extensions = { md = true, markdown = true, mdx = true, txt = true, text = true }

function M.setup()
  local requests = {}
  local selected_paths = {}
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("CodeDiffFileLayout", { clear = true }),
    pattern = { "CodeDiffOpen", "CodeDiffFileSelect", "CodeDiffClose" },
    callback = function(event)
      local tab = event.data and event.data.tabpage
      if not tab then
        return
      end
      requests[tab] = nil
      if event.match == "CodeDiffClose" then
        selected_paths[tab] = nil
        return
      end

      local request = {}
      requests[tab] = request
      local deadline = vim.uv.now() + 5000
      local function apply_layout()
        if requests[tab] ~= request or not vim.api.nvim_tabpage_is_valid(tab) then
          return
        end
        local session = require("codediff.ui.lifecycle").get_session(tab)
        if not session then
          return
        end
        -- A seleção chega antes da leitura assíncrona e da criação dos painéis.
        if session.refresh and session.refresh.loading then
          if vim.uv.now() < deadline then
            vim.defer_fn(apply_layout, 20)
          end
          return
        end
        local path = session.modified and session.modified.absolute
        if not path or path == "" then
          path = session.original and session.original.absolute
        end
        if not path or path == "" or selected_paths[tab] == path then
          return
        end
        selected_paths[tab] = path
        if session.merge or session.result_win then
          return
        end
        local extension = path:lower():match("%.([^./]+)$")
        local layout = text_extensions[extension] and "inline" or "side-by-side"
        if session.layout ~= layout then
          require("codediff.ui.view").toggle_layout(tab)
        end
      end
      vim.schedule(apply_layout)
    end,
  })
end

return M
