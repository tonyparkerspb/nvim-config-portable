require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    close_command = "bdelete! %d",
    right_mouse_command = nil,
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = "▎", -- this should be omitted if indicator style is not 'icon'
      style = "icon"
    },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 10,
    diagnostics = false,
    custom_filter = function(bufnr)
      -- if the result is false, this buffer will be shown, otherwise, this
      -- buffer will be hidden.

      -- filter out filetypes you don't want to see
      local exclude_ft = {"qf", "fugitive", "git"}
      local cur_ft = vim.bo[bufnr].filetype
      local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

      if should_filter then return false end

      return true
    end,
    show_buffer_icons = false,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "bar",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = "id",
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true -- use a "true" to enable the default, or set your own character
      }
    }
    -- highlights = {
    -- fill = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- tab = {fg = '#FF0000', bg = '#00FF00'},
    -- tab = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- tab_selected = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- tab_separator = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- tab_separator_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   underline = '<colour-value-here>'
    -- },
    -- tab_close = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- close_button = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- close_button_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- close_button_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- buffer_visible = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- buffer_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- numbers = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- numbers_visible = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- numbers_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- diagnostic = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- diagnostic_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- diagnostic_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- hint = {
    --   fg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- hint_visible = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- hint_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- hint_diagnostic = {
    --   fg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- hint_diagnostic_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- hint_diagnostic_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- info = {
    --   fg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- info_visible = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- info_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- info_diagnostic = {
    --   fg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- info_diagnostic_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- info_diagnostic_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- warning = {
    --   fg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- warning_visible = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- warning_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- warning_diagnostic = {
    --   fg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- warning_diagnostic_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- warning_diagnostic_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- error = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>'
    -- },
    -- error_visible = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- error_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- error_diagnostic = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>'
    -- },
    -- error_diagnostic_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- error_diagnostic_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   sp = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- modified = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- modified_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- modified_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- duplicate_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   italic = true
    -- },
    -- duplicate_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   italic = true
    -- },
    -- duplicate = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   italic = true
    -- },
    -- separator_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- separator_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- separator = {fg = '<colour-value-here>', bg = '<colour-value-here>'},
    -- indicator_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- indicator_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- pick_selected = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- pick_visible = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- pick = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>',
    --   bold = true,
    --   italic = true
    -- },
    -- offset_separator = {
    --   fg = '<colour-value-here>',
    --   bg = '<colour-value-here>'
    -- },
    -- trunc_marker = {fg = '<colour-value-here>', bg = '<colour-value-here>'}
    -- }
  }
})
