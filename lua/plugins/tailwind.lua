return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          settings = {
            tailwindCSS = {
              classFunctions = { "cn", "clsx", "cva", "twMerge", "tw", "tw\\.[a-z-]+" },
            },
          },
        },
      },
    },
  },
}
