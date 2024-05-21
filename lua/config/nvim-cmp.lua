-- Setup nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `ultisnips` user.
      vim.fn["UltiSnips#Anon"](args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ["<CR>"] = cmp.mapping.confirm({select = true}),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4)
  }),
  sources = {
    {name = "ultisnips"}, -- For ultisnips user.
    {name = "nvim_lsp", max_item_count = 30}, -- For nvim-lsp
    -- { name = "copilot", keyword_length = 0, max_item_count = 3 },
    {name = "path"}, -- for path completion
    {name = "buffer", keyword_length = 2, max_item_count = 10} -- for buffer word completion
    -- { name = "emoji", insert = true }, -- emoji completion
  },
  completion = {keyword_length = 1, completeopt = "menu,noselect"},
  view = {entries = "custom"},
  formatting = {
    format = lspkind.cmp_format({
      mode = "text",
      menu = {
        nvim_lsp = "[LSP]",
        -- copilot = "[Copilot]",
        ultisnips = "[US]",
        nvim_lua = "[Lua]",
        path = "[Path]",
        buffer = "[Buffer]",
        emoji = "[Emoji]",
        omni = "[Omni]"
      }
    })
  }
})

-- cmp.setup.filetype("tex", {
-- 	sources = {
-- 		{ name = "ultisnips" }, -- For ultisnips user.
-- 		{ name = "copilot", group_index = 2 },
-- 		{ name = "omni" },
-- 		{ name = "buffer", keyword_length = 2 }, -- for buffer word completion
-- 		{ name = "path" }, -- for path completion
-- 	},
-- })

--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])
