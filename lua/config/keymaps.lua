vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Rolar para baixo e centralizar" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Rolar para cima e centralizar" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Próximo resultado centralizado" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Resultado anterior centralizado" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Colar sem sobrescrever o registro" })

vim.keymap.set("n", "te", "<cmd>tabnew<cr>", { desc = "Nova aba" })
vim.keymap.set("n", "<Tab>", "gt", { desc = "Próxima aba" })
vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Aba anterior" })
vim.keymap.set("n", "ss", "<cmd>split<cr>", { desc = "Dividir horizontalmente" })
vim.keymap.set("n", "sv", "<cmd>vsplit<cr>", { desc = "Dividir verticalmente" })
vim.keymap.set("n", "sh", "<C-w>h", { desc = "Janela à esquerda" })
vim.keymap.set("n", "sj", "<C-w>j", { desc = "Janela abaixo" })
vim.keymap.set("n", "sk", "<C-w>k", { desc = "Janela acima" })
vim.keymap.set("n", "sl", "<C-w>l", { desc = "Janela à direita" })

vim.keymap.set("n", "<C-p>", LazyVim.pick("files"), { desc = "Buscar arquivos" })
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
