local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local utils = require("utils")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

local lspconfig = require("lspconfig")

-- if utils.executable("pylsp") then
--   lspconfig.pylsp.setup {
--     on_attach = Custom_attach,
--     settings = {
--       pylsp = {
--         plugins = {
--           pylint = { enabled = true, executable = "pylint" },
--           pyflakes = { enabled = false },
--           pycodestyle = { enabled = false },
--           jedi_completion = { fuzzy = true },
--           pyls_isort = { enabled = true },
--           pylsp_mypy = { enabled = true },
--         },
--       },
--     },
--     flags = {
--       debounce_text_changes = 200,
--     },
--     capabilities = capabilities,
--   }
-- else
--   vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
-- end

-- if utils.executable('pyright') then
--   lspconfig.pyright.setup{
--     on_attach = Custom_attach,
--     capabilities = capabilities
--   }
-- else
--   vim.notify("pyright not found!", vim.log.levels.WARN, {title = 'Nvim-config'})
-- end

-- if utils.executable("ltex-ls") then
--   lspconfig.ltex.setup {
--     on_attach = Custom_attach,
--     cmd = { "ltex-ls" },
--     filetypes = { "text", "plaintex", "tex", "markdown" },
--     settings = {
--       ltex = {
--         language = "en"
--       },
--     },
--     flags = { debounce_text_changes = 300 },
-- }
-- end

if utils.executable("clangd") then
  lspconfig.clangd.setup {
    on_attach = Custom_attach,
    capabilities = capabilities,
    filetypes = {"c", "cpp", "cc"},
    flags = {debounce_text_changes = 500}
  }
else
  vim.notify("clangd not found!", vim.log.levels.WARN, {title = "Nvim-config"})
end

-- set up vim-language-server
if utils.executable("vim-language-server") then
  lspconfig.vimls.setup({
    on_attach = Custom_attach,
    flags = {debounce_text_changes = 500},
    capabilities = capabilities
  })
else
  vim.notify("vim-language-server not found!", vim.log.levels.WARN,
             {title = "Nvim-config"})
end

-- set up bash-language-server
if utils.executable("bash-language-server") then
  lspconfig.bashls.setup({
    on_attach = Custom_attach,
    capabilities = capabilities
  })
end

-- set up typescript-language-server
if utils.executable("typescript-language-server") then
  lspconfig.tsserver.setup({
    on_attach = Custom_attach,
    capabilities = capabilities
  })
end

-- if utils.executable("vue-language-server") then
lspconfig.volar.setup({
  on_attach = Custom_attach,
  filetypes = {"javascript", "vue"},
  capabilities = capabilities
})
-- end

-- set up eslint
if utils.executable("eslint") then
  lspconfig.eslint.setup({
    on_attach = Custom_attach,
    capabilities = capabilities
  })
  -- else
  -- 	vim.notify("eslint_d not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- swift setup
if utils.executable("sourcekit-lsp") then
  lspconfig.sourcekit.setup(
    {
      root_dir = lspconfig.util.root_pattern(".git", "Package.swift"),
      on_attach = Custom_attach,
      capabilities = capabilities,
      cmd = {"/usr/bin/sourcekit-lsp"},
    }
  )
end

-- if utils.executable("lua-language-server") then
--   -- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
--   lspconfig.sumneko_lua.setup(
--     {
--       on_attach = Custom_attach,
--       settings = {
--         Lua = {
--           runtime = {
--             -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--             version = "LuaJIT"
--           },
--           diagnostics = {
--             -- Get the language server to recognize the `vim` global
--             globals = {"vim"}
--           },
--           workspace = {
--             -- Make the server aware of Neovim runtime files,
--             -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
--             -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
--             library = {
--               fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
--               fn.stdpath("config")
--             },
--             maxPreload = 2000,
--             preloadFileSize = 50000
--           }
--         }
--       },
--       capabilities = capabilities
--     }
--   )
-- end

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'require'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true)
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {enable = false}
    }
  },
  on_attach = Custom_attach,
  capabilities = capabilities
}

-- Change diagnostic signs.
-- fn.sign_define("DiagnosticSignError", {text = "✗", texthl = "DiagnosticSignError"})
-- fn.sign_define("DiagnosticSignWarn", {text = "!", texthl = "DiagnosticSignWarn"})
-- fn.sign_define("DiagnosticSignInformation", {text = "", texthl = "DiagnosticSignInfo"})
-- fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})

-- global config for diagnostic
diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  severity_sort = true
})

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover,
                                              {border = "rounded"})
