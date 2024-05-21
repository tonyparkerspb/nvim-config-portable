local api = vim.api
local keymap = vim.keymap
local dashboard = require("dashboard")

dashboard.setup({
  theme = 'hyper',
  config = {
    header = {
      "                                                       ",
      "                                                       ",
      "                                                       ",
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      "                                                       ",
      "                                                       "
    },
    shortcut = {
      {
        desc = ' Grep',
        group = '@property',
        action = 'Telescope live_grep',
        key = 'u'
      }, {
        desc = ' Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f'
      }, {
        desc = ' Buffers',
        group = 'DiagnosticHint',
        action = 'Telescope buffers',
        key = 'a'
      }, {
        desc = ' Help tags',
        group = 'Number',
        action = 'Telescope help_tags',
        key = 'd'
      }
    },
    project = {
      enable = true,
      limit = 8,
      icon = '⚓',
      label = 'Projects',
      -- action = 'Telescope find_files cwd='
      action = function(path)
        vim.cmd('cd ' .. path)
        vim.cmd('Neotree')
      end
    }
    -- shortcut = {
    --   {
    --     desc = " Find  File",
    --     action = "Leaderf file --popup",
    --     key = "<Leader> f f",
    --   },
    --   {
    --     desc = " Recently opened files",
    --     action = "Leaderf mru --popup",
    --     key = "<Leader> f r",
    --   },
    --   {
    --     desc = " Project grep",
    --     action = "Leaderf rg --popup",
    --     key = "<Leader> f g",
    --   },
    --   {
    --     desc = " Open Nvim config",
    --     action = "tabnew $MYVIMRC | tcd %:p:h",
    --     key = "<Leader> e v",
    --   },
    --   {
    --     desc = " New file",
    --     action = "enew",
    --     key = "e",
    --   },
    --   {
    --     desc = " Quit Nvim",
    --     action = "qa",
    --     key = "q",
    --   },
    -- }
  }
})

-- api.nvim_create_autocmd("FileType", {
--   pattern = "dashboard",
--   group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
--   callback = function ()
--     keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
--     keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
--   end
-- })
