return {
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight" } },
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts.style = "night"
      opts.transparent = true

      opts.styles = opts.styles or {}
      opts.styles.sidebars = "transparent"
      opts.styles.floats = "transparent"

      local previous_on_highlights = opts.on_highlights
      opts.on_highlights = function(hl, c)
        if previous_on_highlights then
          previous_on_highlights(hl, c)
        end

        -- Neogit commit/log diff view: keep it closer to Tokyo Night instead of
        -- the default high-contrast cyan/red block palette.
        local transparent = "NONE"

        -- Markdown: preserve text colors/styles without shaded backgrounds.
        local markdown_groups = { "@markup.raw.markdown_inline", "RenderMarkdownCode" }
        for i = 1, 6 do
          markdown_groups[#markdown_groups + 1] = "@markup.heading." .. i .. ".markdown"
          markdown_groups[#markdown_groups + 1] = "RenderMarkdownH" .. i .. "Bg"
        end
        for _, group in ipairs(markdown_groups) do
          if type(hl[group]) == "table" then
            hl[group].bg = transparent
          end
        end

        -- Window filename bars (lualine winbar in splits) without the darker strip.
        hl.WinBar = { fg = c.fg_dark, bg = transparent }
        hl.WinBarNC = { fg = c.fg_gutter, bg = transparent }

        hl.NeogitNormal = { fg = c.fg, bg = transparent }
        hl.NeogitSubtleText = { fg = c.comment, bg = transparent }
        hl.NeogitCommitViewHeader = { fg = c.blue, bg = transparent, bold = true }
        hl.NeogitCommitViewDescription = { fg = c.fg, bg = transparent }

        hl.NeogitDiffHeader = { fg = c.cyan, bg = transparent, bold = true }
        hl.NeogitDiffHeaderHighlight = { fg = c.orange, bg = transparent, bold = true }

        hl.NeogitHunkHeader = { fg = c.orange, bg = transparent, bold = true }
        hl.NeogitHunkHeaderHighlight = { fg = c.yellow, bg = transparent, bold = true }
        hl.NeogitHunkHeaderCursor = { fg = c.yellow, bg = transparent, bold = true }
        hl.NeogitHunkMergeHeader = { fg = c.purple, bg = transparent, bold = true }
        hl.NeogitHunkMergeHeaderHighlight = { fg = c.magenta, bg = transparent, bold = true }

        hl.NeogitDiffContext = { fg = c.fg_dark, bg = transparent }
        hl.NeogitDiffContextHighlight = { fg = c.fg, bg = transparent }
        hl.NeogitDiffContextCursor = { fg = c.fg, bg = transparent }

        hl.NeogitDiffAdditions = { fg = c.green, bg = transparent }
        hl.NeogitDiffAdd = { fg = c.green, bg = transparent }
        hl.NeogitDiffAddHighlight = { fg = c.green, bg = transparent }
        hl.NeogitDiffAddCursor = { fg = c.green, bg = transparent }
        hl.NeogitDiffAddInline = { fg = c.bg, bg = c.green, bold = true }

        hl.NeogitDiffDeletions = { fg = c.red, bg = transparent }
        hl.NeogitDiffDelete = { fg = c.red, bg = transparent }
        hl.NeogitDiffDeleteHighlight = { fg = c.red, bg = transparent }
        hl.NeogitDiffDeleteCursor = { fg = c.red, bg = transparent }
        hl.NeogitDiffDeleteInline = { fg = c.bg, bg = c.red, bold = true }

        -- Git/diff syntax groups used inside Neogit log and commit buffers.
        hl.DiffAdd = { fg = c.green, bg = transparent }
        hl.DiffDelete = { fg = c.red, bg = transparent }
        hl.DiffChange = { fg = c.fg, bg = transparent }
        hl.DiffText = { fg = c.yellow, bg = transparent, bold = true }

        hl.diffAdded = { fg = c.green }
        hl.diffRemoved = { fg = c.red }
        hl.diffChanged = { fg = c.blue }
        hl.diffOldFile = { fg = c.red }
        hl.diffNewFile = { fg = c.green }
        hl.diffFile = { fg = c.cyan }
        hl.diffLine = { fg = c.orange, bold = true }
        hl.diffIndexLine = { fg = c.comment }
      end

      return opts
    end,
  },
}
