return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        local root = LazyVim.root()
        -- A .git marker can be empty or invalid; only trust roots recognized by Git.
        local in_git_repo = require("insideee-dev.utils").git_toplevel(root, 1000) ~= nil
        require("neo-tree.command").execute({
          source = "filesystem",
          toggle = true,
          dir = in_git_repo and root or vim.fn.getcwd(),
        }, not in_git_repo and {
          enable_git_status = false,
          filtered_items = { hide_gitignored = false },
        } or nil)
      end,
      desc = "Explorer NeoTree (Project or cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Project or cwd)", remap = true },
  },
  opts = function(_, opts)
    opts.filesystem = opts.filesystem or {}
    opts.filesystem.group_empty_dirs = false

    opts.buffers = opts.buffers or {}
    opts.buffers.group_empty_dirs = false

    opts.git_status = opts.git_status or {}
    opts.git_status.group_empty_dirs = false

    opts.source_selector = opts.source_selector or {}
    opts.source_selector.winbar = false
    opts.source_selector.statusline = false

    opts.window = opts.window or {}
    opts.window.mappings = opts.window.mappings or {}
    -- Open files in a new tab (or focus the tab already showing them); an empty tab is reused.
    local function open_in_tab(state)
      if require("insideee-dev.utils").tab_has_file_window() then
        state.commands.open_tab_drop(state)
      else
        state.commands.open(state)
      end
    end
    opts.window.mappings["<cr>"] = open_in_tab
    opts.window.mappings["o"] = open_in_tab
    opts.window.mappings["Y"] = function(state)
      local node = state.tree:get_node()
      if not node or not node.id then
        vim.notify("No node selected.", vim.log.levels.WARN)
        return
      end

      if vim.fn.has("clipboard") == 0 then
        vim.notify("System clipboard is not available.", vim.log.levels.ERROR)
        return
      end

      local filepath = node:get_id()
      local filename = node.name

      local modify = vim.fn.fnamemodify

      local choices = {
        { label = "Absolute path", value = filepath },
        { label = "Path relative to CWD", value = modify(filepath, ":.") },
        { label = "Path relative to HOME", value = modify(filepath, ":~") },
        { label = "Filename", value = filename },
        { label = "Filename without extension", value = modify(filename, ":r") },
        { label = "Extension of the filename", value = modify(filename, ":e") },
      }

      require("snacks").picker.select(choices, {
        prompt = "Choose to copy to clipboard:",
        format_item = function(item)
          return string.format("%-30s %s", item.label, item.value)
        end,
      }, function(choice)
        if not choice then
          vim.notify("Copy cancelled.", vim.log.levels.INFO)
          return
        end

        local value_to_copy = choice.value
        vim.fn.setreg("+", value_to_copy)
        vim.notify("Copied to clipboard: " .. value_to_copy)
      end)
    end

    return opts
  end,
}
