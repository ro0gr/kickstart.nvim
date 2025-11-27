vim.keymap.set('n', '<c-w>!', ':ResizeWindow<CR>', { noremap = true, silent = true })

vim.pack.add {
  'https://github.com/beauwilliams/focus.nvim',
}

local focus = require 'focus'

-- we just need windows auto-resize, which is enabled by default, and
-- we don't need any other features, so let's disable everything enabled
-- by default.
focus.setup {
  ui = {
    -- this is true by default, so let's disable it
    signcolumn = false,
  },
  autoresize = {
    enable = false,
  },
}

vim.api.nvim_create_user_command('ResizeWindow', function()
  vim.b.focus_config = {
    autoresize = {
      enable = true,
    },
  }

  focus.resize()
end, {})
