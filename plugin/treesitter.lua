vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

require('nvim-treesitter').install {
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
  'gitconfig',
  'gitignore',
  'http',
  'ini',
  'makefile',
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
