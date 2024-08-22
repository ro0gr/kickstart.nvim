return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gc', '<CMD>tab Git commit<CR>', { desc = '[G]it commit' })
      vim.keymap.set('n', '<leader>gac', '<CMD>tab Git commit --amend<CR>', { desc = '[G]it [a]mend [c]ommit' })
      vim.keymap.set('n', '<leader>gB', '<CMD>Gitsigns blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>gl', '<CMD>Flog<CR>', { desc = '[G]it [l]og' })
      vim.keymap.set('n', '<leader>gp', '<CMD>Git push<CR>', { desc = '[G]it [p]ush' })
      vim.keymap.set('n', '<leader>gr', '<CMD>Git rebase<CR>', { desc = '[G]it [r]ebase' })
      vim.keymap.set('n', '<leader>gw', '<CMD>Git write<CR>', { desc = '[G]it [w]rite' })
    end,
  },
  'tommcdo/vim-fubitive',
  'tpope/vim-rhubarb',
  {
    'sindrets/diffview.nvim',
    config = function()
      vim.keymap.set('n', '<leader>gs', '<CMD>DiffviewOpen<CR>', { desc = '[G]it [s]tatus' })
    end,
  },
  {
    'rbong/vim-flog',
    lazy = true,
    cmd = { 'Flog', 'Flogsplit', 'Floggit' },
    dependencies = {
      'tpope/vim-fugitive',
    },
  },
}
