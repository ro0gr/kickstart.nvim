vim.pack.add {
  'https://github.com/echasnovski/mini.pick',
}

local MiniPick = require 'mini.pick'

MiniPick.setup()
vim.ui.select = MiniPick.ui_select
