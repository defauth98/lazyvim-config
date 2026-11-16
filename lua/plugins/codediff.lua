return {
  "esmuellert/codediff.nvim",
  lazy = true,
  cmd = "CodeDiff",
  init = function()
    -- O CodeDiff ativa scrollbind nos dois painéis; sincronize ambos os eixos.
    vim.opt.scrollopt:append({ "ver", "hor", "jump" })
    require("insideee-dev.git-diff").setup()
    -- O CodeDiff desativa wrap também nas atualizações assíncronas dos painéis.
    local wrap_pending = false
    local function enable_diff_wrap()
      if wrap_pending or not package.loaded["codediff.ui.lifecycle"] then
        return
      end
      wrap_pending = true
      vim.schedule(function()
        wrap_pending = false
        local lifecycle = require("codediff.ui.lifecycle")
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          local session = lifecycle.get_session(tab)
          if session then
            for _, key in ipairs({ "original_win", "modified_win", "result_win" }) do
              local win = session[key]
              if win and vim.api.nvim_win_is_valid(win) and not vim.wo[win].wrap then
                vim.wo[win].wrap = true
              end
            end
          end
        end
      end)
    end
    local group = vim.api.nvim_create_augroup("CodeDiffWrap", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = { "CodeDiffOpen", "CodeDiffFileSelect", "CodeDiffVirtualFileLoaded" },
      callback = enable_diff_wrap,
    })
    vim.api.nvim_create_autocmd("OptionSet", {
      group = group,
      pattern = "wrap",
      callback = enable_diff_wrap,
    })
    -- OptionSet não dispara dentro dos autocmds em que o plugin reaplica nowrap.
    vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter", "WinEnter", "FileType", "TabEnter" }, {
      group = group,
      callback = enable_diff_wrap,
    })
  end,
  opts = {
    diff = { layout = "side-by-side" },
    keymaps = {
      view = {
        next_hunk = { "]c", "<leader>hh" },
        prev_hunk = { "[c", "<leader>hp" },
      },
    },
    explorer = {
      view_mode = "tree",
      flatten_dirs = true,
      auto_refresh = true,
    },
  },
}
