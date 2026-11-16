vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Rolar para baixo e centralizar" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Rolar para cima e centralizar" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Próximo resultado centralizado" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Resultado anterior centralizado" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Colar sem sobrescrever o registro" })

-- `te` (nova aba com Neo-tree) fica em lua/plugins/neotree.lua.
vim.keymap.set("n", "<Tab>", "gt", { desc = "Próxima aba" })
vim.keymap.set("n", "<C-Tab>", "gT", { desc = "Aba anterior" })
vim.keymap.set("n", "ss", "<cmd>split<cr>", { desc = "Dividir horizontalmente" })
vim.keymap.set("n", "sv", "<cmd>vsplit<cr>", { desc = "Dividir verticalmente" })
vim.keymap.set("n", "sh", "<C-w>h", { desc = "Janela à esquerda" })
vim.keymap.set("n", "sj", "<C-w>j", { desc = "Janela abaixo" })
vim.keymap.set("n", "sk", "<C-w>k", { desc = "Janela acima" })
vim.keymap.set("n", "sl", "<C-w>l", { desc = "Janela à direita" })

vim.keymap.set("n", "<C-p>", LazyVim.pick("files"), { desc = "Buscar arquivos" })
-- <leader><space> opens the chosen file in a new tab (or focuses the tab already showing it);
-- <C-p> and ;f keep opening it in the current window. ;f replaces LazyVim's <leader>ff.
vim.keymap.set(
  "n",
  "<leader><space>",
  LazyVim.pick("files", { confirm = "tabdrop" }),
  { desc = "Buscar arquivos (nova aba)" }
)
pcall(vim.keymap.del, "n", "<leader>ff")

-- Pickers under ";" (Snacks). They open results in the current window.
vim.keymap.set("n", ";f", LazyVim.pick("files", { hidden = true }), { desc = "Buscar arquivos (inclui ocultos)" })
vim.keymap.set("n", ";r", LazyVim.pick("live_grep", { hidden = true }), { desc = "Buscar texto (inclui ocultos)" })
vim.keymap.set("n", ";;", function()
  Snacks.picker.resume()
end, { desc = "Reabrir picker anterior" })
vim.keymap.set("n", ";b", function()
  -- drop focuses the window (in any tab) that already shows the buffer.
  Snacks.picker.buffers({ confirm = "drop" })
end, { desc = "Buffers (vai à janela aberta)" })
vim.keymap.set("n", ";e", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnósticos" })
vim.keymap.set("n", ";n", function()
  Snacks.picker.notifications()
end, { desc = "Histórico de notificações" })
vim.keymap.set("n", ";h", function()
  Snacks.picker.git_diff()
end, { desc = "Trechos alterados (Git)" })
vim.keymap.set("n", ";c", function()
  Snacks.picker.lsp_incoming_calls()
end, { desc = "Chamadas recebidas (LSP)" })
vim.keymap.set("n", "<C-f>", LazyVim.pick("live_grep"), { desc = "Buscar texto no projeto" })

-- Toggle inline diagnostics while keeping signs and underlines.
local inline_diagnostics
Snacks.toggle({
  name = "Inline Diagnostics",
  get = function()
    return vim.diagnostic.config().virtual_text ~= false
  end,
  set = function(enabled)
    if enabled then
      vim.diagnostic.config({ virtual_text = inline_diagnostics or true })
    else
      inline_diagnostics = vim.diagnostic.config().virtual_text
      vim.diagnostic.config({ virtual_text = false })
    end
  end,
}):map("<leader>uv")

-- Toggle comment with CTRL+/
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<C-/>", "<Esc>gcc", { remap = true, desc = "Toggle comment" })
-- Fallback para terminais que enviam <C-_> ao invés de <C-/>
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<C-_>", "<Esc>gcc", { remap = true, desc = "Toggle comment" })

local utils = require("insideee-dev.utils")
vim.keymap.set("n", "<leader>yr", function()
  utils.copy_to_clipboard(false)
end, { desc = "Copiar caminho relativo" })
vim.keymap.set("n", "<leader>yf", function()
  utils.copy_to_clipboard(true)
end, { desc = "Copiar arquivo e linha" })
vim.keymap.set("n", "<leader>r", utils.replace_hex_with_hsl, { desc = "Converter hex para HSL na linha" })
for index = 1, 6 do
  vim.keymap.set("n", "<leader>" .. index, function()
    local buffers = vim.tbl_filter(function(buf)
      return vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())
    if buffers[index] then
      vim.api.nvim_set_current_buf(buffers[index])
    end
  end, { desc = "Go to buffer " .. index })
end

-- Recursos Git e buffers já fornecidos pelo Snacks/LazyVim.
vim.keymap.set("n", "<leader>go", function()
  Snacks.gitbrowse()
end, { desc = "Open Git remote" })
vim.keymap.set("n", "<leader>gF", "<cmd>!git fetch origin<cr>", { desc = "Git Fetch origin" })
vim.keymap.set("n", "<leader>th", function()
  Snacks.bufdelete({
    filter = function(buf)
      return vim.fn.bufwinid(buf) == -1
    end,
  })
end, { desc = "Close hidden buffers" })
vim.keymap.set("n", "<leader>tu", function()
  Snacks.bufdelete({
    filter = function(buf)
      return vim.api.nvim_buf_get_name(buf) == ""
    end,
  })
end, { desc = "Close unnamed buffers" })
