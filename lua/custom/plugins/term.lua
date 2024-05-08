return {
  'voldikss/vim-floaterm',
  config = function()
    vim.keymap.set('n', '<M-`>', ':FloatermToggle<CR>')
    vim.keymap.set('t', '<M-`>', '<C-\\><C-n>:FloatermToggle<CR>')
    -- for safety, allow to delete the terminal buffer only from the normal mode
    vim.keymap.set('n', '<M-Del>', ':FloatermKill<CR>')
    vim.keymap.set('n', '<M-Tab>', ':FloatermNext<CR>')
    vim.keymap.set('t', '<M-Tab>', '<C-\\><C-n>:FloatermNext<CR>')
    vim.keymap.set('n', '<M-S-Tab>', ':FloatermPrev<CR>')
    vim.keymap.set('t', '<M-S-Tab>', '<C-\\><C-n>:FloatermPrev<CR>')
    vim.keymap.set('n', '<M-S-=>', ':FloatermNew<CR>')
    vim.keymap.set('t', '<M-S-=>', '<C-\\><C-n>:FloatermNew<CR>')
  end,
}
