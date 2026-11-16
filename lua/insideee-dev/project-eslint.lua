local M = {}
local namespace = vim.api.nvim_create_namespace("project-eslint")
local projects = {}

local function scan(root)
  local state = projects[root]
  if state.running then
    state.pending = true
    return
  end
  local executable = root .. "/node_modules/.bin/eslint"
  if vim.fn.executable(executable) ~= 1 then
    return
  end
  state.running = true
  vim.system({ executable, ".", "--format", "json" }, { cwd = root, text = true }, function(result)
    vim.schedule(function()
      state.running = false
      local ok, reports = pcall(vim.json.decode, result.stdout or "")
      if result.code > 1 or not ok or type(reports) ~= "table" then
        vim.notify("ESLint do projeto: " .. (result.stderr or "saída inválida"), vim.log.levels.WARN)
      else
        for bufnr in pairs(state.buffers or {}) do
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.diagnostic.reset(namespace, bufnr)
          end
        end
        state.buffers = {}
        for _, report in ipairs(reports) do
          -- Only create buffers for files that actually have problems.
          local bufnr = #(report.messages or {}) > 0 and vim.fn.bufadd(report.filePath) or nil
          -- The LSP owns diagnostics for open files, including unsaved changes.
          if bufnr and #vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" }) == 0 then
            local diagnostics = {}
            for _, message in ipairs(report.messages or {}) do
              local line = math.max((message.line or 1) - 1, 0)
              local col = math.max((message.column or 1) - 1, 0)
              diagnostics[#diagnostics + 1] = {
                lnum = line,
                col = col,
                end_lnum = message.endLine and message.endLine - 1 or line,
                end_col = message.endColumn and message.endColumn - 1 or col,
                message = message.message,
                severity = message.severity == 2 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                source = "eslint (projeto)",
                code = type(message.ruleId) == "string" and message.ruleId or nil,
              }
            end
            if #diagnostics > 0 then
              vim.diagnostic.set(namespace, bufnr, diagnostics)
              state.buffers[bufnr] = true
            end
          end
        end
      end
      if state.pending then
        state.pending = false
        scan(root)
      end
    end)
  end)
end

function M.refresh(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]
  local root = client and client.config.root_dir
  if not root then
    return
  end
  projects[root] = projects[root] or {}
  scan(root)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("ProjectEslint", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == "eslint" then
        vim.diagnostic.reset(namespace, event.buf)
      end
    end,
  })
  vim.api.nvim_create_user_command("EslintProject", function()
    M.refresh(0)
  end, { desc = "Executar ESLint manualmente no projeto inteiro" })
end

return M
