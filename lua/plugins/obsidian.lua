return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cmd = "Obsidian",
    dependencies = { "folke/snacks.nvim" },
    init = function()
      -- Preserva os atalhos <C-a>/<C-x> do OpenCode nas notas.
      vim.g.obsidian_default_keymap = false
    end,
    keys = {
      { "<leader>nf", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: buscar nota" },
      { "<leader>ns", "<cmd>Obsidian search<cr>", desc = "Obsidian: buscar texto" },
      { "<leader>nn", "<cmd>Obsidian new<cr>", desc = "Obsidian: nova nota" },
      { "<leader>nd", "<cmd>Obsidian today<cr>", desc = "Obsidian: nota de hoje" },
      { "<leader>nb", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: backlinks" },
      { "<leader>nl", "<cmd>Obsidian links<cr>", desc = "Obsidian: links da nota" },
      { "<leader>nt", "<cmd>Obsidian tags<cr>", desc = "Obsidian: tags" },
      { "<leader>ni", "<cmd>Obsidian template<cr>", desc = "Obsidian: inserir template" },
      { "<leader>nx", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Obsidian: alternar checkbox" },
      { "<leader>no", "<cmd>Obsidian open<cr>", desc = "Obsidian: abrir no aplicativo" },
    },
    opts = function()
      return {
        legacy_commands = false,
        workspaces = {
          {
            name = "pessoal",
            path = "~/obsidian/obsidian-vault-pessoal",
          },
        },
        picker = { name = "snacks.picker" },
        note_id_func = require("obsidian.builtin").title_id,
        -- Evita acrescentar propriedades automaticamente às notas existentes.
        frontmatter = { enabled = false },
        daily_notes = {
          folder = "TODOLIST",
          date_format = "YYYY-MM-DD",
        },
        templates = {
          folder = "Templates",
          date_format = "DD.MM.YYYY",
        },
        attachments = { folder = "anexos" },
        callbacks = {
          enter_note = function()
            vim.wo.conceallevel = 2
            local actions = require("obsidian.actions")
            vim.keymap.set("n", "<CR>", actions.smart_action, {
              buffer = true,
              expr = true,
              desc = "Obsidian: seguir link ou alternar checkbox",
            })
            vim.keymap.set("n", "]o", function()
              actions.nav_link("next", true)
            end, { buffer = true, desc = "Obsidian: próximo link" })
            vim.keymap.set("n", "[o", function()
              actions.nav_link("prev", true)
            end, { buffer = true, desc = "Obsidian: link anterior" })
          end,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          root_dir = function(bufnr, on_dir)
            -- O obsidian-ls cuida dos links do vault; o Marksman usa regras diferentes.
            if vim.fs.root(bufnr, { ".obsidian" }) then
              return
            end
            on_dir(vim.fs.root(bufnr, vim.lsp.config.marksman.root_markers))
          end,
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>n", group = "Obsidian / notas" } } },
  },
}
