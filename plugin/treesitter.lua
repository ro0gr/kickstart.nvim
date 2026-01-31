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

vim.keymap.set(nxo, ';', require('demicolon.repeat_jump').next)
vim.keymap.set(nxo, ',', require('demicolon.repeat_jump').prev)
