vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<C-p>", LazyVim.pick("files"))
vim.keymap.set("n", "<C-f>", LazyVim.pick("live_grep"))

-- Toggle comment with CTRL+/
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<C-/>", "<Esc>gcc", { remap = true, desc = "Toggle comment" })
-- Fallback para terminais que enviam <C-_> ao invés de <C-/>
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("i", "<C-_>", "<Esc>gcc", { remap = true, desc = "Toggle comment" })


-- Atalhos do experimento Part 3.
local tools = require("insideee-dev.utils")
vim.keymap.set("n", "<leader>yr", function() tools.copy_to_clipboard(false) end, { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>yR", function() tools.copy_to_clipboard(true) end, { desc = "Copy path with line" })
vim.keymap.set("n", "<leader>r", tools.replace_hex_with_HSL, { desc = "Convert hex to HSL on line" })
for index = 1, 6 do
  vim.keymap.set("n", "<leader>" .. index, function()
    local buffers = vim.tbl_filter(function(buf) return vim.bo[buf].buflisted end, vim.api.nvim_list_bufs())
    if buffers[index] then vim.api.nvim_set_current_buf(buffers[index]) end
  end, { desc = "Go to buffer " .. index })
end

-- Recursos Git e buffers já fornecidos pelo Snacks/LazyVim.
vim.keymap.set("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open Git remote" })
vim.keymap.set("n", "<leader>th", function()
  Snacks.bufdelete({ filter = function(buf) return vim.fn.bufwinid(buf) == -1 end })
end, { desc = "Close hidden buffers" })
vim.keymap.set("n", "<leader>tu", function()
  Snacks.bufdelete({ filter = function(buf) return vim.api.nvim_buf_get_name(buf) == "" end })
end, { desc = "Close unnamed buffers" })
