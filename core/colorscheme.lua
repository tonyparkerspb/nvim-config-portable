-- this is our single source of truth created above
local base16_theme_fname = vim.fn.expand(vim.env.HOME..'/.config/.base16_theme')
-- this function is the only way we should be setting our colorscheme
local function set_colorscheme(name)
    -- write our colorscheme back to our single source of truth
    vim.fn.writefile({name}, base16_theme_fname)
    -- set Neovim's colorscheme
    vim.cmd('colorscheme '..name)
    -- execute `kitty @ set-colors -c <color>` to change terminal window's
    -- colors and newly created terminal windows colors
    vim.loop.spawn('kitty', {
        args = {
            '@',
            'set-colors',
            '-c',
            string.format('.config/base16-kitty/colors/%s.conf', name)
        }
    }, nil)
end

set_colorscheme(vim.fn.readfile(base16_theme_fname)[1])

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local telescope_action_set = require "telescope.actions.set"

function get_colorscheme()
    -- get our base16 colorschemes
    local colors = vim.fn.getcompletion('', 'color')
    -- we're trying to mimic VSCode so we'll use dropdown theme
    local theme = require('telescope.themes').get_dropdown()
    -- create our picker
    require('telescope.pickers').new(theme, {
        prompt = 'Change Base16 Colorscheme',
        finder = require('telescope.finders').new_table {
            results = colors
        },
        sorter = require('telescope.config').values.generic_sorter(theme),
        attach_mappings = function(bufnr)
            -- change the colors upon selection
            actions.select_default:replace(function()
                set_colorscheme(action_state.get_selected_entry().value)
                actions.close(bufnr)
            end)
            telescope_action_set.shift_selection:enhance({
                -- change the colors upon scrolling
                post = function()
                    set_colorscheme(action_state.get_selected_entry().value)
                end
            })
            return true
        end
    }):find()
end


vim.keymap.set('n', '<leader>c', '<cmd>lua get_colorscheme()<CR>')
