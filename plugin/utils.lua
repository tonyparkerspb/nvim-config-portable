-- everything in plugins dir will be loaded by default by neovim

local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

Capabilities = require("cmp_nvim_lsp").default_capabilities()

Custom_attach = function(client, bufnr)
  -- Mappings.
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, {desc = "go to definition"})
  map("n", "<C-]>", vim.lsp.buf.definition)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "<C-i", vim.lsp.buf.signature_help)
  map("n", "<space>rn", vim.lsp.buf.rename, {desc = "varialbe rename"})
  map("n", "gr", vim.lsp.buf.references, {desc = "show references"})
  map("n", "[d", diagnostic.goto_prev, {desc = "previous diagnostic"})
  map("n", "]d", diagnostic.goto_next, {desc = "next diagnostic"})
  map("n", "]D", diagnostic.open_float, {desc = "get diagnostic"})
  map("n", "<space>q", diagnostic.setqflist, {desc = "put diagnostic to qf"})
  map("n", "<space>ca", vim.lsp.buf.code_action, {desc = "LSP code action"})
  map("n", "<space>wa", vim.lsp.buf.add_workspace_folder,
      {desc = "add workspace folder"})
  map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder,
      {desc = "remove workspace folder"})
  map("n", "<space>wl",
      function() inspect(vim.lsp.buf.list_workspace_folders()) end,
      {desc = "list workspace folder"})

  -- Set some key bindings conditional on server capabilities
  -- if client.server_capabilities.documentFormattingProvider then
  -- 	-- alt + shift + f
  -- 	map("n", "Ï", vim.lsp.buf.format, { desc = "format code" })
  -- end

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = {"BufLeave", "CursorMoved", "InsertEnter", "FocusLost"},
        border = "rounded",
        source = "always", -- show source in diagnostic popup window
        prefix = " "
      }

      if not vim.b.diagnostics_pos then vim.b.diagnostics_pos = {nil, nil} end

      local cursor_pos = api.nvim_win_get_cursor(0)
      if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~=
          vim.b.diagnostics_pos[2]) and #diagnostic.get() > 0 then
        diagnostic.open_float(nil, float_opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end
  })

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

    local gid =
        api.nvim_create_augroup("lsp_document_highlight", {clear = true})
    api.nvim_create_autocmd("CursorHold", {
      group = gid,
      buffer = bufnr,
      callback = function() lsp.buf.document_highlight() end
    })

    api.nvim_create_autocmd("CursorMoved", {
      group = gid,
      buffer = bufnr,
      callback = function() lsp.buf.clear_references() end
    })
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, {title = "Nvim-config"})
  end
end
