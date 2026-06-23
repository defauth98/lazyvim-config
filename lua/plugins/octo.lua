return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      -- or "fzf-lua" or "snacks" or "default"
      picker = "snacks",
      -- bare Octo command opens picker of commands
      enable_builtin = true,
      use_local_fs = true,
      reviews = {
        auto_show_threads = true,
        focus = "right",
      },
      file_panel = {
        size = 18,
        icons = true,
      },
      mappings = {
        pull_request = {
          review_start = { lhs = "<leader>or", desc = "start a review for the current PR" },
          review_resume = { lhs = "<leader>oR", desc = "resume a pending review for the current PR" },
          list_changed_files = { lhs = "<leader>of", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<leader>od", desc = "show PR diff" },
        },
        review_diff = {
          submit_review = { lhs = "<leader>os", desc = "submit review" },
          discard_review = { lhs = "<leader>ox", desc = "discard review" },
          add_review_comment = { lhs = "<leader>ca", desc = "add a new review comment", mode = { "n", "x" } },
          add_review_suggestion = { lhs = "<leader>sa", desc = "add a new review suggestion", mode = { "n", "x" } },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          toggle_viewed = { lhs = "<space>", desc = "toggle viewed state" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        file_panel = {
          submit_review = { lhs = "<leader>os", desc = "submit review" },
          discard_review = { lhs = "<leader>ox", desc = "discard review" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          toggle_viewed = { lhs = "<space>", desc = "toggle viewed state" },
          select_next_entry = { lhs = "]q", desc = "move to next changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review", mode = { "n" } },
          comment_review = { lhs = "<C-m>", desc = "comment review", mode = { "n" } },
          request_changes = { lhs = "<C-r>", desc = "request changes review", mode = { "n" } },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab", mode = { "n" } },
        },
      },
    },
    keys = {
      {
        "<leader>oi",
        "<CMD>Octo issue list<CR>",
        desc = "List GitHub Issues",
      },
      {
        "<leader>op",
        "<CMD>Octo pr list<CR>",
        desc = "List GitHub PullRequests",
      },
      {
        "<leader>og",
        "<CMD>Octo discussion list<CR>",
        desc = "List GitHub Discussions",
      },
      {
        "<leader>on",
        "<CMD>Octo notification list<CR>",
        desc = "List GitHub Notifications",
      },
      {
        "<leader>o/",
        function()
          require("octo.utils").create_base_search_command({ include_current_repo = true })
        end,
        desc = "Search GitHub",
      },
      {
        "<leader>or",
        "<CMD>Octo review start<CR>",
        desc = "Start PR Review",
      },
      {
        "<leader>oR",
        "<CMD>Octo review resume<CR>",
        desc = "Resume PR Review",
      },
      {
        "<leader>ob",
        "<CMD>Octo review browse<CR>",
        desc = "Browse PR Review",
      },
      {
        "<leader>oc",
        "<CMD>Octo review comments<CR>",
        desc = "Review Pending Comments",
      },
      {
        "<leader>os",
        "<CMD>Octo review submit<CR>",
        desc = "Submit PR Review",
      },
      {
        "<leader>ox",
        "<CMD>Octo review discard<CR>",
        desc = "Discard PR Review",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons", -- optional if file_panel.icons is a function
    },
  },
}
