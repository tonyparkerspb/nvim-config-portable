local api = vim.api
local fn = vim.fn

-- local utils = require("utils")

-- The root dir to install all plugins. Plugins are under opt/ or start/ sub-directory.
vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

--- Install packer if it has not been installed.
--- Return:
--- true: if this is a fresh install of packer
--- false: if packer has been installed
local function packer_ensure_install()
  -- Where to install packer.nvim -- the package manager (we make it opt)
  local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

  if fn.glob(packer_dir) ~= "" then return false end

  -- Auto-install packer in case it hasn't been installed.
  vim.api.nvim_echo({{"Installing packer.nvim", "Type"}}, true, {})

  local packer_repo = "https://github.com/tonyparkerspb/packer.nvim"
  local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo,
                                    packer_dir)
  vim.cmd(install_cmd)

  return true
end

local fresh_install = packer_ensure_install()

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require("packer.util")

-- check if firenvim is active
local firenvim_not_active = function() return not vim.g.started_by_firenvim end

packer.startup({
  function(use)
    -- it is recommended to put impatient.nvim before any other plugins
    use({"tonyparkerspb/impatient.nvim", config = [[require('impatient')]]})

    use({"tonyparkerspb/packer.nvim", opt = true})

    use({
      "tonyparkerspb/Comment.nvim",
      config = function() require("Comment").setup() end
    })

    use({"tonyparkerspb/vim-jsdoc"})

    use({"tonyparkerspb/git-messenger.vim"})

    use({"tonyparkerspb/lspkind.nvim", event = "VimEnter"})
    -- auto-completion engine
    use({
      "tonyparkerspb/nvim-cmp",
      after = "lspkind.nvim",
      config = [[require('config.nvim-cmp')]]
    })

    use({"tonyparkerspb/cmp-nvim-lsp", after = "nvim-cmp"})
    use({"tonyparkerspb/cmp-path", after = "nvim-cmp"})
    use({"tonyparkerspb/cmp-buffer", after = "nvim-cmp"})
    use({"tonyparkerspb/cmp-omni", after = "nvim-cmp"})
    use({"tonyparkerspb/cmp-nvim-ultisnips", after = {"nvim-cmp", "ultisnips"}})
    -- if vim.g.is_mac then
    use({"tonyparkerspb/cmp-emoji", after = "nvim-cmp"})
    -- end

    use({
      "tonyparkerspb/mason.nvim",
      after = "cmp-nvim-lsp",
      config = function() require("mason").setup() end
    })
    use({
      "tonyparkerspb/mason-lspconfig.nvim",
      after = "mason.nvim",
      config = function() require("mason-lspconfig").setup() end
    })
    -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
    use({
      "tonyparkerspb/nvim-lspconfig",
      after = "mason-lspconfig.nvim",
      config = [[require('config.lsp')]]
    })
    -- use({"tonyparkerspb/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.lsp')]]})

    use({"tonyparkerspb/nvim-lint"})

    --   if vim.g.is_mac then
    use({
      "tonyparkerspb/nvim-treesitter",
      event = "BufEnter",
      run = ":TSUpdate",
      config = [[require('config.treesitter')]]
    })
    --   end

    --   -- Python indent (follows the PEP8 style)
    --   use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

    --   -- Python-related text object
    --   use { "jeetsukumaran/vim-pythonsense", ft = { "python" } }

    --   use { "machakann/vim-swap", event = "VimEnter" }

    --   -- IDE for Lisp
    --   if utils.executable("sbcl") then
    --     -- use 'kovisoft/slimv'
    --     use { "vlime/vlime", rtp = "vim/", ft = { "lisp" } }
    --   end

    --   -- Super fast buffer jump
    use({
      "tonyparkerspb/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function() require("config.nvim_hop") end, 2000)
      end
    })

    --   -- Show match number and index for searching
    --   use {
    --     "kevinhwang91/nvim-hlslens",
    --     branch = "main",
    --     keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
    --     config = [[require('config.hlslens')]],
    --   }

    --   -- File search, tag search and more
    --   if vim.g.is_win then
    use({"tonyparkerspb/LeaderF", cmd = "Leaderf"})
    --   else
    --     use { "Yggdroot/LeaderF", cmd = "Leaderf", run = ":LeaderfInstallCExtension" }
    --   end

    use({
      "tonyparkerspb/telescope.nvim",
      config = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        local custom_actions = {}

        function custom_actions.fzf_multi_select(prompt_bufnr)
          local picker = action_state.get_current_picker(prompt_bufnr)
          local num_selections = table.getn(picker:get_multi_selection())

          if num_selections > 1 then
            -- actions.file_edit throws - context of picker seems to change
            -- actions.file_edit(prompt_bufnr)
            actions.send_selected_to_qflist(prompt_bufnr)
            actions.open_qflist()
          else
            actions.file_edit(prompt_bufnr)
          end
        end

        require("telescope").setup({
          defaults = {
            mappings = {
              i = {
                -- close on escape
                ["<esc>"] = actions.close,
                ["<tab>"] = actions.toggle_selection +
                    actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection +
                    actions.move_selection_previous,
                ["<cr>"] = custom_actions.fzf_multi_select
              },
              n = {
                ["<tab>"] = actions.toggle_selection +
                    actions.move_selection_next,
                ["<s-tab>"] = actions.toggle_selection +
                    actions.move_selection_previous,
                ["<cr>"] = custom_actions.fzf_multi_select
              }
            }
          }
        })
        require("telescope").setup({
          extensions = {
            file_browser = {
              -- theme = "ivy",
              -- disables netrw and use telescope-file-browser in its place
              hijack_netrw = true
              -- mappings = {
              -- 	["i"] = {
              -- 		-- your custom insert mode mappings
              -- 	},
              -- 	["n"] = {
              -- 		-- your custom normal mode mappings
              -- 	},
              -- },
            }
          }
        })
        require("telescope").load_extension("file_browser")
      end,
      requires = {{"tonyparkerspb/plenary.nvim"}}
    })
    -- search emoji and other symbols
    use({"tonyparkerspb/telescope-symbols.nvim", after = "telescope.nvim"})

    -- use({"tonyparkerspb/shades-of-purple.vim"})
    -- use({ "navarasu/onedark.nvim" })
    -- use({ "sainnhe/edge" })
    -- use({ "sainnhe/sonokai" })
    -- use({ "sainnhe/gruvbox-material" })
    -- use({ "shaunsingh/nord.nvim" })
    -- use({ "sainnhe/everforest" })
    -- use({"tonyparkerspb/nightfox.nvim"})
    -- use({ "rebelot/kanagawa.nvim" })
    -- use({ "catppuccin/nvim", as = "catppuccin" })
    -- use({"tonyparkerspb/neovim", as = "rose-pine"})
    -- use({ "olimorris/onedarkpro.nvim" })
    -- use({ "tanvirtin/monokai.nvim" })
    -- use({ "marko-cerovac/material.nvim" })
    -- use({"tonyparkerspb/neovim-ayu"})
    -- use({"tonyparkerspb/nvim"})
    -- use({"tonyparkerspb/aquarium-vim"})
    -- use({"tonyparkerspb/tokyodark.nvim"})
    -- use({"tonyparkerspb/moonlight.nvim"})
    -- use({"tonyparkerspb/calvera-dark.nvim"})
    -- use({"tonyparkerspb/tokyonight.nvim"})
    -- use({"tonyparkerspb/oceanic-next"})
    -- use({"tonyparkerspb/aurora"})
    -- use({ "tonyparkerspb/starry.nvim" })
    -- use({'tonyparkerspb/github-nvim-theme'})

    -- use({
    --   'projekt0n/github-nvim-theme',
    --   config = function()
    --     require('github-theme').setup({
    --       -- ...
    --     })
    --
    --     vim.cmd('colorscheme github_dark')
    --   end
    -- })

    use({"tonyparkerspb/nvim-web-devicons", event = "VimEnter"})

    use({
      "tonyparkerspb/lualine.nvim",
      event = "VimEnter",
      cond = firenvim_not_active,
      after = "vim-obsession",
      config = [[require('config.statusline')]]
    })

    use({
      "tonyparkerspb/bufferline.nvim",
      event = "VimEnter",
      cond = firenvim_not_active,
      config = [[require('config.bufferline')]]
    })

    -- fancy start screen
    use({
      "tonyparkerspb/dashboard-nvim",
      event = "VimEnter",
      commit = "2baa64f",
      config = [[require('config.dashboard-nvim')]]
    })

    use({
      "tonyparkerspb/indent-blankline.nvim",
      event = "VimEnter",
      config = [[require('config.indent-blankline')]]
    })

    --   -- Highlight URLs inside vim
    --   use { "itchyny/vim-highlighturl", event = "VimEnter" }

    --   -- notification plugin
    --   use {
    --     "rcarriga/nvim-notify",
    --     event = "BufEnter",
    --     config = function()
    --       vim.defer_fn(function()
    --         require("config.nvim-notify")
    --       end, 2000)
    --     end,
    --   }

    --   -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
    --   -- not be possible since we maybe in a server which disables GUI.
    --   if vim.g.is_win or vim.g.is_mac then
    --     -- open URL in browser
    --     use { "tyru/open-browser.vim", event = "VimEnter" }
    --   end

    --   -- Only install these plugins if ctags are installed on the system
    --   if utils.executable("ctags") then
    --     -- show file tags in vim window
    --     use { "liuchengxu/vista.vim", cmd = "Vista" }
    --   end

    --   -- Snippet engine and snippet template
    use({"tonyparkerspb/ultisnips", event = "InsertEnter"})
    --   use { "honza/vim-snippets", after = "ultisnips" }

    --   -- Automatic insertion and deletion of a pair of characters
    use({"tonyparkerspb/delimitMate", event = "InsertEnter"})

    --   -- Multiple cursor plugin like Sublime Text?
    use("tonyparkerspb/vim-visual-multi")

    --   -- Autosave files on certain events
    --   use { "907th/vim-auto-save", event = "InsertEnter" }

    --   -- Show undo history visually
    use({"tonyparkerspb/vim-mundo", cmd = {"MundoToggle", "MundoShow"}})

    --   -- better UI for some nvim actions
    --   use {'stevearc/dressing.nvim'}

    --   -- Manage your yank history
    use({"tonyparkerspb/yanky.nvim", config = [[require('config.yanky')]]})

    --   -- Handy unix command inside Vim (Rename, Move etc.)
    use({"tonyparkerspb/vim-eunuch", cmd = {"Rename", "Delete"}})

    --   -- Repeat vim motions
    --   use { "tpope/vim-repeat", event = "VimEnter" }

    use({"tonyparkerspb/better-escape.vim", event = {"InsertEnter"}})

    --   if vim.g.is_mac then
    --     use { "lyokha/vim-xkbswitch", event = { "InsertEnter" } }
    --   elseif vim.g.is_win then
    --     use { "Neur1n/neuims", event = { "InsertEnter" } }
    --   end

    --   -- Auto format tools
    -- use({ "tonyparkerspb/neoformat", cmd = { "Neoformat" } })
    use({
      "tonyparkerspb/formatter.nvim",
      config = [[require('config.formatter')]]
    })

    --   -- Git command inside vim
    use({
      "tonyparkerspb/vim-fugitive",
      event = "User InGitRepo",
      config = [[require('config.fugitive')]]
    })

    --   -- Better git log display
    use({
      "tonyparkerspb/vim-flog",
      requires = "tonyparkerspb/vim-fugitive",
      cmd = {"Flog"}
    })

    use({
      "tonyparkerspb/vim-conflicted",
      requires = "tonyparkerspb/vim-fugitive",
      cmd = {"Conflicted"}
    })

    --   use {
    --     "ruifm/gitlinker.nvim",
    --     requires = "nvim-lua/plenary.nvim",
    --     event = "User InGitRepo",
    --     config = [[require('config.git-linker')]],
    --   }

    --   -- Show git change (change, delete, add) signs in vim sign column
    use({"tonyparkerspb/gitsigns.nvim", config = [[require('config.gitsigns')]]})

    --   -- Better git commit experience
    --   use { "rhysd/committia.vim", opt = true, setup = [[vim.cmd('packadd committia.vim')]] }

    use {
      "tonyparkerspb/nvim-bqf",
      ft = "qf",
      config = [[require('config.bqf')]]
    }

    --   -- Another markdown plugin
    --   use { "preservim/vim-markdown", ft = { "markdown" } }

    --   -- Faster footnote generation
    --   use { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } }

    --   -- Vim tabular plugin for manipulate tabular, required by markdown plugins
    --   use { "godlygeek/tabular", cmd = { "Tabularize" } }

    --   -- Markdown previewing (only for Mac and Windows)
    --   if vim.g.is_win or vim.g.is_mac then
    --     use {
    --       "iamcco/markdown-preview.nvim",
    --       run = "cd app && npm install",
    --       ft = { "markdown" },
    --     }
    --   end

    use({
      "tonyparkerspb/zen-mode.nvim",
      cmd = "ZenMode",
      config = [[require('config.zen-mode')]]
    })

    --   if vim.g.is_mac then
    use({"tonyparkerspb/vim-grammarous", ft = {"markdown"}})
    --   end

    --   use { "chrisbra/unicode.vim", event = "VimEnter" }

    --   -- Additional powerful text object for vim, this plugin should be studied
    --   -- carefully to use its full power
    use({"tonyparkerspb/targets.vim", event = "VimEnter"})

    --   -- Plugin to manipulate character pairs quickly
    use({"tonyparkerspb/vim-sandwich", event = "VimEnter"})

    --   -- Add indent object for vim (useful for languages like Python)
    use({"tonyparkerspb/vim-indent-object", event = "VimEnter"})

    --   -- Only use these plugin on Windows and Mac and when LaTeX is installed
    --   if utils.executable("latex") then
    --     use { "lervag/vimtex", ft = { "tex" } }
    --   end

    --   -- Since tmux is only available on Linux and Mac, we only enable these plugins
    --   -- for Linux and Mac
    --   if utils.executable("tmux") then
    --     -- .tmux.conf syntax highlighting and setting check
    --     use { "tmux-plugins/vim-tmux", ft = { "tmux" } }
    --   end

    --   -- Modern matchit implementation
    use({"tonyparkerspb/vim-matchup", event = "VimEnter"})

    --   use { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } }

    --   -- Asynchronous command execution
    --   use { "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } }

    --   use { "cespare/vim-toml", ft = { "toml" }, branch = "main" }

    --   -- Edit text area in browser using nvim
    --   if vim.g.is_win or vim.g.is_mac then
    --     use {
    --       "glacambre/firenvim",
    --       run = function()
    --         fn["firenvim#install"](0)
    --       end,
    --       opt = true,
    --       setup = [[vim.cmd('packadd firenvim')]],
    --     }
    --   end

    --   -- Debugger plugin
    --   if vim.g.is_win or vim.g.is_linux then
    --     use { "sakhnik/nvim-gdb", run = { "bash install.sh" }, opt = true, setup = [[vim.cmd('packadd nvim-gdb')]] }
    --   end

    --   -- Session management plugin
    -- use({"tonyparkerspb/vim-obsession", cmd = "Obsession"})

    --   if vim.g.is_linux then
    --     use { "ojroques/vim-oscyank", cmd = { "OSCYank", "OSCYankReg" } }
    --   end

    --   -- The missing auto-completion for cmdline!
    use({
      "tonyparkerspb/wilder.nvim",
      config = function()
        local wilder = require("wilder")
        wilder.setup({modes = {":", "/", "?"}})

        wilder.set_option("pipeline", {
          wilder.branch(wilder.python_file_finder_pipeline({
            -- to use ripgrep : {'rg', '--files'}
            -- to use fd      : {'fd', '-tf'}
            file_command = {"rg", "--files"},
            -- to use fd      : {'fd', '-td'}
            dir_command = {"fd", "-td", "-printf", "%P\n"},
            -- use {'cpsm_filter'} for performance, requires cpsm vim plugin
            -- found at https://github.com/nixprime/cpsm
            filters = {"fuzzy_filter", "difflib_sorter"}
          }), wilder.cmdline_pipeline({
            -- sets the language to use, 'vim' and 'python' are supported
            language = "python",
            -- 0 turns off fuzzy matching
            -- 1 turns on fuzzy matching
            -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
            fuzzy = 1
          }), wilder.python_search_pipeline({
            -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
            pattern = wilder.python_fuzzy_pattern(),
            -- omit to get results in the order they appear in the buffer
            sorter = wilder.python_difflib_sorter(),
            -- can be set to 're2' for performance, requires pyre2 to be installed
            -- see :h wilder#python_search() for more details
            engine = "re"
          }))
        })

        -- wilder.set_option("pipeline", {
        -- 	wilder.branch(
        -- 		wilder.python_file_finder_pipeline({
        -- 			-- to use ripgrep : {'rg', '--files'}
        -- 			-- to use fd      : {'fd', '-tf'}
        -- 			file_command = { "find", ".", "-type", "f", "-printf", "%P\n" },
        -- 			-- to use fd      : {'fd', '-td'}
        -- 			dir_command = { "find", ".", "-type", "d", "-printf", "%P\n" },
        -- 			-- use {'cpsm_filter'} for performance, requires cpsm vim plugin
        -- 			-- found at https://github.com/nixprime/cpsm
        -- 			filters = { "fuzzy_filter", "difflib_sorter" },
        -- 		}),
        -- 		wilder.cmdline_pipeline(),
        -- 		wilder.python_search_pipeline()
        -- 	),
        -- })

        wilder.set_option("renderer",
                          wilder.popupmenu_renderer(
                              wilder.popupmenu_border_theme({
              -- highlighter applies highlighting to the candidates
              highlighter = wilder.basic_highlighter(),
              highlights = {
                border = "Normal",
                accent = wilder.make_hl("WilderAccent", "Pmenu", {
                  {a = 1}, {a = 1}, {foreground = "#f4468f"}
                })
              },
              pumblend = 10,
              max_height = "20%",
              min_width = "20%",
              border = "rounded",
              left = {" ", wilder.popupmenu_devicons()},
              right = {" ", wilder.popupmenu_scrollbar()},
              apply_incsearch_fix = 1
            })))
      end
    })

    --   -- showing keybindings
    use({
      "tonyparkerspb/which-key.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function() require("config.which-key") end, 2000)
      end
    })

    --   -- show and trim trailing whitespaces
    --   use { "jdhao/whitespace.nvim", event = "VimEnter" }

    --   -- file explorer
    -- use({
    -- 	"tonyparkerspb/nvim-tree.lua",
    -- 	requires = { "tonyparkerspb/nvim-web-devicons" },
    -- 	config = [[require('config.nvim-tree')]],
    -- })
    use({
      "tonyparkerspb/neo-tree.nvim",
      branch = "3",
      requires = {
        "tonyparkerspb/plenary.nvim", "tonyparkerspb/nvim-web-devicons", -- not strictly required, but recommended
        "tonyparkerspb/nui.nvim", {
          -- only needed if you want to use the commands with "_with_window_picker" suffix
          "tonyparkerspb/nvim-window-picker",
          -- tag = "v1.*",
          config = function()
            require("window-picker").setup({
              autoselect_one = true,
              include_current = false,
              filter_rules = {
                -- filter using buffer options
                bo = {
                  -- if the file type is one of following, the window will be ignored
                  filetype = {"neo-tree", "neo-tree-popup", "notify"},
                  -- if the buffer type is one of following, the window will be ignored
                  buftype = {"terminal", "quickfix"}
                }
              },
              other_win_hl_color = "#e35e4f"
            })
          end
        }
      },
      config = function() require("config.neo-tree") end
    })

    -- use({
    -- 	"github/copilot.vim",
    -- })

    -- use({
    --   "tonyparkerspb/gen.nvim",
    --   config = function()
    --     require("gen").setup({
    --       model = "llama2-uncensored:70b", -- The default model to use.
    --       host = "localhost", -- The host running the Ollama service.
    --       port = "11434", -- The port on which the Ollama service is listening.
    --       display_mode = "float", -- The display mode. Can be "float" or "split".
    --       show_prompt = false, -- Shows the Prompt submitted to Ollama.
    --       show_model = false, -- Displays which model you are using at the beginning of your chat session.
    --       no_auto_close = false, -- Never closes the window automatically.
    --       init = function(options)
    --         pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    --       end,
    --       -- Function to initialize Ollama
    --       command = function(options)
    --         return
    --             "curl --silent --no-buffer -X POST http://" .. options.host ..
    --                 ":" .. options.port .. "/api/generate -d $body"
    --       end,
    --       -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
    --       -- This can also be a command string.
    --       -- The executed command must return a JSON object with { response, context }
    --       -- (context property is optional).
    --       -- list_models = '<omitted lua function>', -- Retrieves a list of model names
    --       debug = false -- Prints errors and the command which is run.
    --     })
    --   end
    -- })

    use({
      "tonyparkerspb/trouble.nvim",
      requires = "tonyparkerspb/nvim-web-devicons",
      config = function() require("trouble").setup({}) end
    })

    -- use({
    --   "tonyparkerspb/copilot.lua",
    --   config = function()
    --     require('copilot').setup({
    --       panel = {
    --         enabled = true,
    --         auto_refresh = false,
    --         keymap = {
    --           jump_prev = "[[",
    --           jump_next = "]]",
    --           accept = "<CR>",
    --           refresh = "gr",
    --           open = "<M-CR>"
    --         },
    --         layout = {
    --           position = "right", -- | top | left | right
    --           ratio = 0.4
    --         }
    --       },
    --       suggestion = {
    --         enabled = true,
    --         auto_trigger = true,
    --         debounce = 75,
    --         keymap = {
    --           accept = "<M-l>",
    --           accept_line = "<M-k>",
    --           accept_word = "<M-j>",
    --           next = "<M-]>",
    --           prev = "<M-[>",
    --           dismiss = "<C-]>"
    --         }
    --       },
    --       filetypes = {
    --         javascript = true,
    --         typescript = true,
    --         c = true,
    --         cpp = true,
    --         lua = true,
    --         python = true,
    --         vue = true,
    --         html = true,
    --         ["*"] = false
    --       },
    --       copilot_node_command = 'node', -- Node.js version must be > 18.x
    --       server_opts_overrides = {}
    --     })
    --   end
    -- })

    -- use({
    -- 	"tonyparkerspb/copilot-cmp",
    -- 	after = { "copilot.lua" },
    -- 	config = function()
    -- 		require("copilot_cmp").setup()
    -- 	end,
    -- })

    -- use(
    --   {
    --     "tonyparkerspb/nvim-base16"
    --   }
    -- )

    -- use({ "neoclide/coc.nvim", branch = "release" })

    --   use { "ii14/emmylua-nvim", ft = "lua" }

    use({
      "tonyparkerspb/fidget.nvim",
      after = "nvim-lspconfig",
      config = [[require('config.fidget-nvim')]]
    })

    -- use({"tonyparkerspb/neodev.nvim"})

    use({
      "tonyparkerspb/telescope-file-browser.nvim",
      requires = {"tonyparkerspb/telescope.nvim", "tonyparkerspb/plenary.nvim"}
    })

    -- use({"tonyparkerspb/ai.vim"})

    use({"tonyparkerspb/Vim-Jinja2-Syntax"})

    -- use({"tonyparkerspb/nnn.vim"})

    use({"tonyparkerspb/lazygit.nvim"})

    use({
      "tonyparkerspb/nvim-config-local",
      config = function()
        require("config-local").setup({
          -- Default options (optional)

          -- Config file patterns to load (lua supported)
          config_files = {".clangd.lua", ".nvim.lua", ".nvimrc", ".exrc"},

          -- Where the plugin keeps files data
          hashfile = vim.fn.stdpath("data") .. "/config-local",

          autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
          commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
          silent = false, -- Disable plugin messages (Config loaded/ignored)
          lookup_parents = false -- Lookup config files in parent directories
        })
      end
    })

    -- use {
    --   "tonyparkerspb/zenbones.nvim",
      -- Optionally install Lush. Allows for more configuration or extending the colorscheme
      -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
      -- In Vim, compat mode is turned on as Lush only works in Neovim.
    --   requires = "tonyparkerspb/lush.nvim"
    -- }

    use 'tonyparkerspb/solarized.nvim'

    use {
      "tonyparkerspb/neovim-session-manager",
      -- after plenary
      after = "plenary.nvim",
      config = [[require('config.session-manager')]]
    }

    -- use(
    --   {
    --     "tonyparkerspb/typescript-tools.nvim",
    --     requires = {"tonyparkerspb/plenary.nvim", "tonyparkerspb/nvim-lspconfig"},
    --     config = function()
    --       require("typescript-tools").setup {}
    --     end
    --   }
    -- )

    --
    -- use({ "tonyparkerspb/indentLine" })
  end,
  config = {
    max_jobs = 16,
    compile_path = packer_util.join_paths(fn.stdpath("data"), "site", "lua",
                                          "packer_compiled.lua")
  }
})

-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
  -- We run packer.sync() here, because only after packer.startup, can we know which plugins to install.
  -- So plugin installation should be done after the startup process.
  packer.sync()
else
  local status, _ = pcall(require, "packer_compiled")
  if not status then
    local msg = "File packer_compiled.lua not found: run PackerSync to fix!"
    vim.notify(msg, vim.log.levels.ERROR, {title = "nvim-config"})
  end
end

-- Auto-generate packer_compiled.lua file
api.nvim_create_autocmd({"BufWritePost"}, {
  pattern = "*/nvim/lua/plugins.lua",
  group = api.nvim_create_augroup("packer_auto_compile", {clear = true}),
  callback = function(ctx)
    local cmd = "source " .. ctx.file
    vim.cmd(cmd)
    vim.cmd("PackerCompile")
    vim.notify("PackerCompile done!", vim.log.levels.INFO,
               {title = "Nvim-config"})
  end
})
