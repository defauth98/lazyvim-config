return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        win = { width = 0.98, height = 0.95 },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>GitDiff<cr>", desc = "Git Diff" },
      { "<leader>gD", false },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.attach_to_untracked = true
      require("insideee-dev.gitsigns-wrap").setup()
      local on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        local result = on_attach and on_attach(buffer)
        -- O LazyVim cria estes atalhos a cada buffer anexado ao GitSigns.
        for _, key in ipairs({ "<leader>ghd", "<leader>ghD", "<leader>ghp", "<leader>gp" }) do
          pcall(vim.keymap.del, "n", key, { buffer = buffer })
        end
        vim.keymap.set("n", "<leader>ga", function()
          require("gitsigns").stage_buffer(vim.schedule_wrap(function(err)
            if err then
              vim.notify(tostring(err), vim.log.levels.ERROR)
              return
            end
            -- A prévia inline tem marcas próprias que o stage não remove.
            local ns = vim.api.nvim_get_namespaces().gitsigns_preview_inline
            if ns and vim.api.nvim_buf_is_valid(buffer) then
              vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
            end
            local events = package.loaded["neo-tree.events"]
            if events then
              events.fire_event(events.GIT_EVENT)
            end
          end))
        end, { buffer = buffer, desc = "Stage do arquivo atual" })
        vim.keymap.set("n", "<leader>hd", function()
          vim.wo.wrap = true
          require("gitsigns").preview_hunk_inline()
        end, { buffer = buffer, desc = "Diff inline no buffer" })
        vim.keymap.set("n", "<leader>hh", function()
          require("gitsigns").nav_hunk("next")
        end, { buffer = buffer, desc = "Próximo hunk" })
        vim.keymap.set("n", "<leader>hp", function()
          require("gitsigns").nav_hunk("prev")
        end, { buffer = buffer, desc = "Hunk anterior" })
        return result
      end
    end,
  },
}
