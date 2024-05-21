local keymap = vim.keymap
local api = vim.api
local uv = vim.loop
local commentApi = require("Comment.api")

-- Leader key
keymap.set({"n", "x"}, "<Space>", "<NOP>", {noremap = true, silent = true})
vim.g.mapleader = " "

-- Start obsession
-- keymap.set("n", "<leader>;;", "<cmd>Obsession<cr>", {desc = "start obsession"})
 
-- Move current line up and down
keymap.set("n", "<˚>", '<cmd>call utils#SwitchLine(line("."), "up")<cr>',
           {desc = "move line up"})
keymap.set("n", "<∆>", '<cmd>call utils#SwitchLine(line("."), "down")<cr>',
           {desc = "move line down"})

-- Move current visual-line selection up and down
keymap.set("x", "<˚>", '<cmd>call utils#MoveSelection("up")<cr>',
           {desc = "move selection up"})
keymap.set("x", "<∆>", '<cmd>call utils#MoveSelection("down")<cr>',
           {desc = "move selection down"})

-- Go to start or end of line easier
keymap.set({"n", "x"}, "H", "^")
keymap.set({"n", "x"}, "L", "g_")

-- Support of default behavior
-- delete with yanking
keymap.set("n", "<leader>d", "d", {desc = "delete with yanking"})
keymap.set("v", "<leader>d", "d", {desc = "delete with yanking"})

-- change/cut with yanking
keymap.set("n", "<leader>c", "c", {desc = "change/cut with yanking"})
keymap.set("v", "<leader>c", "c", {desc = "change/cut with yanking"})

-- replace currently selected text with default register
-- with yanking it
keymap.set("n", "<leader>p", "p",
           {desc = "replace currently selected text with yanking it"})
keymap.set("v", "<leader>p", "p",
           {desc = "replace currently selected text with yanking it"})

-- Remap delete, change, and paste to not yank
-- delete without yanking
keymap.set("n", "d", "\"_d", {desc = "delete without yanking"})
keymap.set("v", "d", "\"_d", {desc = "delete without yanking"})

-- change/cut without yanking
keymap.set("n", "c", "\"_c", {desc = "change/cut without yanking"})
keymap.set("v", "c", "\"_c", {desc = "change/cut without yanking"})

-- x without yanking
keymap.set("n", "x", "\"_x", {desc = "x without yanking"})

-- replace currently selected text with default register
-- without yanking it
keymap.set("v", "p", "\"_dP",
           {desc = "replace currently selected text without yanking it"})

-- Copy entire buffer.
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", {desc = "yank entire buffer"})

-- Copy entire buffer.
keymap.set("n", "<leader>v", "ggVG", {desc = "select entire buffer"})

-- Toggle cursor column
keymap.set("n", "<leader>cl", "<cmd>call utils#ToggleCursorCol()<cr>",
           {desc = "toggle cursor column"})

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-l>", "<C-o>$")
keymap.set("i", "<C-h>", "<C-o>^")

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

-- Delete the word to the left of the cursor
keymap.set("i", "<A-BS>", "<C-w>")

-- Delete the word to the right of the cursor
keymap.set("i", "<A-DEL>", "<esc><leader>dei")

-- Gen plugin bindings
keymap.set({ 'n', 'v' }, '<leader>]', ':Gen<CR>')

-- Copilot
-- vim.g.copilot_no_tab_map = true
-- keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {silent = true, expr = true})

-- Move between buffers (bufferline)
keymap.set("n", "Ò", ":bnext<CR>")
keymap.set("n", "Ó", ":bprev<CR>")
-- Close buffer - https://stackoverflow.com/questions/4465095/how-to-delete-a-buffer-in-vim-without-losing-the-split-window
keymap.set("n", "∑", ":bn | bd #<CR>")

-- Comments
-- keymap.set("n", "<C-.>", "gcc")
-- keymap.set("x", "<C-.>", "gc")

-- NvimTree
-- keymap.set("n", "<leader>e", ":NvimTreeFindFile<CR>")

keymap.set("n", "<C-.>", commentApi.call("toggle.linewise.current", "g@$"),
           {expr = true, desc = "Comment current line"})
keymap.set("x", "<C-.>", commentApi.call("toggle.blockwise", "g@$"),
           {expr = true, desc = "Comment current visual selection"})

-- Move between windows by ctrl + alt + hjkl
keymap.set("n", "<C-A-h>", "<C-w>h")
keymap.set("n", "<C-A-j>", "<C-w>j")
keymap.set("n", "<C-A-k>", "<C-w>k")
keymap.set("n", "<C-A-l>", "<C-w>l")

-- COC go to definition
-- keymap.set("n", "gd", "<cmd>call CocActionAsync('jumpDefinition')<cr>", { silent = true })
-- keymap.set("n", "gD", "<cmd>call CocAction('jumpDefinition', v:false)<cr>", { silent = true })

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",
           {desc = "find files"})
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",
           {desc = "live grep"})
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {desc = "buffers"})
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",
           {desc = "help tags"})
keymap.set("n", "<leader>fa", "<cmd>Telescope lsp_code_actions<cr>",
           {desc = "code actions"})
keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>",
           {desc = "references"})
keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>",
           {desc = "definitions"})
keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",
           {desc = "document symbols"})
keymap.set("n", "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>",
           {desc = "workspace symbols"})
keymap.set("n", "<leader>ft", "<cmd>Telescope treesitter<cr>",
           {desc = "treesitter"})
keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", {desc = "commands"})
keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>", {desc = "marks"})
keymap.set("n", "<leader>fo", "<cmd>Telescope vim_options<cr>",
           {desc = "vim options"})
keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", {desc = "keymaps"})
keymap.set("n", "<leader>fl", "<cmd>Telescope loclist<cr>", {desc = "loclist"})
keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<cr>", {desc = "quickfix"})
keymap.set("n", "<leader>fp", "<cmd>Telescope filetypes<cr>",
           {desc = "filetypes"})
keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>",
           {desc = "file browser"})
keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>",
           {desc = "document diagnostics"})

-- Lazygit
keymap.set("n", "<leader>i", ":LazyGit<cr>", {desc = "Lazygit"})

-- fast cursor movements
keymap.set("n", "<C-h>", "10h")
keymap.set("n", "<C-j>", "10j")
keymap.set("n", "<C-k>", "10k")
keymap.set("n", "<C-l>", "10l")

-- diagnostic window
keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {desc = "trouble"})

-- formatter
-- alt + shift + f
keymap.set("n", "Ï", "<cmd>:Format<cr>", {desc = "format code"})

keymap.set("n", "<F3>", "<cmd>:noh<cr>", {desc = "clear search highlight"})

-- telescope file browser
keymap.set("n", "<space>fF",
           ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
           {noremap = true})

-- close all other windows (:only)
keymap.set("n", "<leader>o", ":only<CR>", {noremap = true})
