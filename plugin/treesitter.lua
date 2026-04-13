vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

require('nvim-treesitter').install {
  'c',
  'glimmer',
  'javascript',
  'lua',
  'json',
  'html',
  'scss',
  'typescript',
  'rust',
  'python',
  'xml',
  'css',
  'bash',
  'dockerfile',
  'gitignore',
  'http',
  'ini',
  'markdown',
  'ninja',
  'regex',
  'toml',
  'vim',
  'yaml',
  'zig',
  'scala',
  'java',
}

local on_pack_changed = function(ev)
  local name = ev.data.spec.name

  print('Pack changed: ' .. name)
  if name == 'nvim-treesitter' then
    vim.cmd 'TSUpdate'
  end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = on_pack_changed })

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
}

-- ";"/"," to repeat motions. This is misplaced logically, but it depends on the
-- treesitter-textobjects plugin being loaded first. So let's keep it here for now.
vim.pack.add { 'https://github.com/mawkler/demicolon.nvim' }
require('demicolon').setup {
  keymaps = {
    repeat_motions = 'stateful',
  },
}

local nxo = { 'n', 'x', 'o' }

local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
vim.keymap.set(nxo, ';', ts_repeat_move.repeat_last_move_next)
vim.keymap.set(nxo, ',', ts_repeat_move.repeat_last_move_previous)

require('nvim-treesitter-textobjects').setup {
  move = {
    set_jumps = true,
  },
}

local ts_move = require 'nvim-treesitter-textobjects.move'

vim.keymap.set(nxo, ']]', function()
  ts_move.goto_next_start({ '@block.outer', '@function.outer', '@class.outer' }, 'textobjects')
end, { desc = 'Next block start' })

vim.keymap.set(nxo, '][', function()
  ts_move.goto_next_end({ '@block.outer', '@function.outer', '@class.outer' }, 'textobjects')
end, { desc = 'Next block end' })

vim.keymap.set(nxo, '[[', function()
  ts_move.goto_previous_start({ '@block.outer', '@function.outer', '@class.outer' }, 'textobjects')
end, { desc = 'Previous block start' })

vim.keymap.set(nxo, '[]', function()
  ts_move.goto_previous_end({ '@block.outer', '@function.outer', '@class.outer' }, 'textobjects')
end, { desc = 'Previous block end' })
