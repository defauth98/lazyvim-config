local M = {}

function M.open()
  local root = vim.t.git_diff_root
  if not root then
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.bo.buftype == "" and file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
    root = require("insideee-dev.utils").git_toplevel(cwd)
    if not root then
      vim.notify("O arquivo ou diretório atual não pertence a um repositório Git.", vim.log.levels.WARN)
      return
    end
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    if vim.t[tab].git_diff_root == root then
      vim.api.nvim_set_current_tabpage(tab)
      return
    end
  end

  vim.cmd("DiffviewOpen -C" .. vim.fn.fnameescape(root))
  local view = require("diffview.lib").get_current_view()
  if view and view.tabpage then
    vim.t[view.tabpage].git_diff_root = root
  end
end

function M.setup()
  vim.api.nvim_create_user_command("GitDiff", M.open, { desc = "Abrir diff Git" })
end

return M
