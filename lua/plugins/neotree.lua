return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  opts = function(_, opts)
    opts.filesystem = opts.filesystem or {}
    opts.filesystem.group_empty_dirs = false

    opts.event_handlers = opts.event_handlers or {}
    table.insert(opts.event_handlers, {
      event = "after_render",
      handler = function(state)
        if state.name ~= "filesystem" or state.search_pattern or state.initial_expansion_path == state.path then
          return
        end
        local root = state.tree:get_node(state.path)
        if not root then
          return
        end
        state.initial_expansion_path = state.path
        local path = state.path
        vim.schedule(function()
          if state.path ~= path or not vim.api.nvim_win_is_valid(state.winid or -1) then
            return
          end
          local filesystem = require("neo-tree.sources.filesystem")
          for _, id in ipairs(root:get_child_ids()) do
            local node = state.tree:get_node(id)
            if node and node.type == "directory" and not node:is_expanded() then
              filesystem.toggle_directory(state, node)
            end
          end
        end)
      end,
    })

    opts.buffers = opts.buffers or {}
    opts.buffers.group_empty_dirs = false

    opts.git_status = opts.git_status or {}
    opts.git_status.group_empty_dirs = false

    opts.source_selector = opts.source_selector or {}
    opts.source_selector.winbar = true
    opts.source_selector.statusline = true

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
