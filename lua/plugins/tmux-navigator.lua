return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<m-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Painel à esquerda" },
    { "<m-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Painel abaixo" },
    { "<m-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Painel acima" },
    { "<m-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Painel à direita" },
    { "<m-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Painel anterior" },
  },
}
