local M = {}

-- Check the current package and workspace ancestors without scanning node_modules.
function M.has_dependency(directory, dependency, root)
  while directory do
    local manifest = directory .. "/package.json"
    if vim.uv.fs_stat(manifest) then
      local ok, package = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(manifest), "\n"))
      end)
      if ok and type(package) == "table" then
        for _, section in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
          if type(package[section]) == "table" and package[section][dependency] then
            return true
          end
        end
      end
    end
    if directory == root then
      break
    end
    local parent = vim.fs.dirname(directory)
    if parent == directory then
      break
    end
    directory = parent
  end
  return false
end

return M
