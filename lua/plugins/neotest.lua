return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "haydenmeade/neotest-jest",
  },
  opts = {
    adapters = {
      ["neotest-jest"] = {
        -- Optional: customize jest command
        jestCommand = "npm test --",
        env = { CI = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      },
    },
  },
}
