-- Keep the statusline background transparent when the colorscheme reloads.
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.theme = function()
      local theme = require("lualine.utils.loader").load_theme("auto")
      for _, mode in pairs(theme) do
        for _, section in ipairs({ "b", "c" }) do
          if mode[section] then
            mode[section].bg = "None"
          end
        end
      end
      return theme
    end
    opts.options.globalstatus = true
    opts.options.disabled_filetypes = {
      statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
      winbar = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
    }
    opts.options.refresh = opts.options.refresh or {}
    opts.options.refresh.events = vim.list_extend(opts.options.refresh.events or {}, {
      "RecordingEnter",
      "RecordingLeave",
      "DiagnosticChanged",
      "BufModifiedSet",
    })

    local function project_root()
      local root = LazyVim.root.get({ normalize = true })
      local cwd = LazyVim.root.cwd()
      if root ~= cwd then
        return vim.fs.basename(root)
      end
    end

    local function recording()
      local register = vim.fn.reg_recording()
      return register ~= "" and ("REC @" .. register) or ""
    end

    local function is_file_window(win)
      local buf = vim.api.nvim_win_get_buf(win)
      return vim.api.nvim_win_get_config(win).relative == "" and vim.bo[buf].buftype == "" and vim.bo[buf].buflisted
    end

    -- The tabline already names the focused file; the winbar only helps tell file splits apart.
    local function show_window_file()
      if not is_file_window(0) then
        return false
      end
      local count = 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if is_file_window(win) then
          count = count + 1
        end
      end
      return count > 1
    end

    local function window_file()
      local filename = vim.fn.expand("%:t")
      if filename == "" then
        return ""
      end
      local icon = require("nvim-web-devicons").get_icon(filename, nil, { default = true })
      return icon .. " " .. filename .. (vim.bo.modified and " [+]" or "")
    end

    opts.sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        {
          project_root,
          cond = function()
            return project_root() ~= nil
          end,
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path({ relative = "cwd", length = 0 }) },
      },
      lualine_x = {
        {
          recording,
          cond = function()
            return recording() ~= ""
          end,
          color = "DiagnosticError",
        },
        {
          "diagnostics",
          symbols = {
            error = LazyVim.config.icons.diagnostics.Error,
            warn = LazyVim.config.icons.diagnostics.Warn,
            info = LazyVim.config.icons.diagnostics.Info,
            hint = LazyVim.config.icons.diagnostics.Hint,
          },
        },
        {
          "diff",
          symbols = {
            added = LazyVim.config.icons.git.added,
            modified = LazyVim.config.icons.git.modified,
            removed = LazyVim.config.icons.git.removed,
          },
          source = function()
            local status = vim.b.gitsigns_status_dict
            if status then
              return { added = status.added, modified = status.changed, removed = status.removed }
            end
          end,
        },
      },
      lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 0 } } },
      lualine_z = { { "location", padding = { left = 0, right = 1 } } },
    }
    -- Colors come from the transparent theme above instead of fixed Tokyo Night values.
    opts.winbar = {
      lualine_x = { { window_file, cond = show_window_file, padding = { left = 1, right = 1 } } },
    }
    opts.inactive_winbar = {
      lualine_x = { { window_file, cond = show_window_file, padding = { left = 1, right = 1 } } },
    }
  end,
}
