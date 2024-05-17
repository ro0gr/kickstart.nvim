return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gs', '<CMD>vertical Git<CR>', { desc = 'Git status' })
      vim.keymap.set('n', '<leader>gB', '<CMD>Git blame<CR>', { desc = 'Git blame' })
      vim.keymap.set('n', '<leader>gc', '<CMD>Git commit<CR>', { desc = 'Git commit' })
      vim.keymap.set('n', '<leader>gd', '<CMD>Git diff<CR>', { desc = 'Git diff' })
      vim.keymap.set('n', '<leader>gl', '<CMD>Git log<CR>', { desc = 'Git log' })
      vim.keymap.set('n', '<leader>gp', '<CMD>Git push<CR>', { desc = 'Git push' })
      vim.keymap.set('n', '<leader>gr', '<CMD>Git rebase<CR>', { desc = 'Git rebase' })
      vim.keymap.set('n', '<leader>gw', '<CMD>Git write<CR>', { desc = 'Git write' })
    end,
  },
  'tommcdo/vim-fubitive',
  'tpope/vim-rhubarb',
}
