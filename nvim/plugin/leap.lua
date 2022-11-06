vim.keymap.set('', 'n', "<Plug>(leap-forward)", {})
vim.keymap.set('', 't', "<Plug>(leap-backward)", {})

local decoration = '#875f5f'
vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { fg = "#eeeeee", bg = decoration, bold = true })

require('leap').setup {
  case_sensitive = false,
  safe_labels = { "t", "n", "h", "s", "u", "w", "j", "m", "k", "v", "q", "c", "r", "l", "z" },
  labels = { "t", "n", "h", "s", "e", "o", "u", "a", "w", "j", "m", "k", "v", "q", "c", "r", "l", "z" },

  special_keys = {
    repeat_search = '<enter>',
    next_target    = '<enter>',
    prev_target    = '<tab>',
    next_group    = '<space>',
    prev_group    = '<tab>',
    eol           = '<space>',
  },
}
