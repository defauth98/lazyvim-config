-- OpenCode owns <C-a>/<C-x> (lua/plugins/opencode.lua); Dial moves to +/-.
local function dial(increment, g)
  local mode = vim.fn.mode(true)
  local is_visual = mode == "v" or mode == "V" or mode == "\22"
  local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (is_visual and "visual" or "normal")
  local group = vim.g.dials_by_ft[vim.bo.filetype] or "default"
  return require("dial.map")[func](group)
end

return {
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", mode = { "n", "v" }, false },
      { "<C-x>", mode = { "n", "v" }, false },
      {
        "+",
        function()
          return dial(true)
        end,
        expr = true,
        mode = { "n", "v" },
        desc = "Incrementar (Dial)",
      },
      {
        "-",
        function()
          return dial(false)
        end,
        expr = true,
        mode = { "n", "v" },
        desc = "Decrementar (Dial)",
      },
    },
  },
}
