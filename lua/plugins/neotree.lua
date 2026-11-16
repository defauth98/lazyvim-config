-- Open Neo-tree at the Git project root, or at the cwd when the root is not a valid repository.
local function open_explorer(root, toggle)
  -- A .git marker can be empty or invalid; only trust roots recognized by Git.
  local in_git_repo = require("insideee-dev.utils").git_toplevel(root, 1000) ~= nil
  require("neo-tree.command").execute({
    source = "filesystem",
    toggle = toggle,
    dir = in_git_repo and root or vim.fn.getcwd(),
  }, not in_git_repo and {
    enable_git_status = false,
    filtered_items = { hide_gitignored = false },
  } or nil)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  keys = {
    {
      "<leader>fe",
      function()
        open_explorer(LazyVim.root(), true)
      end,
      desc = "Explorer NeoTree (Project or cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Project or cwd)", remap = true },
    {
      "te",
      function()
        -- Resolve the project from the current file before the new tab replaces it with an empty buffer.
        local root = LazyVim.root()
        vim.cmd("tabnew")
        open_explorer(root, false)
      end,
      desc = "Nova aba com Neo-tree",
    },
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
    opts.window.mappings["o"] = "open"
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
