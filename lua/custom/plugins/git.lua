return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gB', '<CMD>Gitsigns blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>tgb', '<CMD>Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [b]lame' })
      vim.keymap.set('n', '<leader>gl', '<CMD>Flog<CR>', { desc = '[G]it [l]og' })
      vim.keymap.set('n', '<leader>gd', '<CMD>Gitsigns diffthis<CR>', { desc = '[G]it [d]iff file' })
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
