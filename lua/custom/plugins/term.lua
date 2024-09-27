vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'customize terminal buffers appearance',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd 'setlocal signcolumn=no'
  end,
})

return {
  'voldikss/vim-floaterm',
  config = function()
    vim.keymap.set('n', '<M-`>', ':FloatermToggle<CR>', { silent = true })

    vim.keymap.set('t', '<M-`>', '<C-\\><C-n>:FloatermToggle<CR>', { silent = true })
    -- for safety, allow to delete the terminal buffer only from the normal mode
    vim.keymap.set('n', '<M-Del>', ':FloatermKill<CR>', { silent = true })
    vim.keymap.set('n', '<M-Tab>', ':FloatermNext<CR>', { silent = true })
    vim.keymap.set('t', '<M-Tab>', '<C-\\><C-n>:FloatermNext<CR>', { silent = true })
    vim.keymap.set('n', '<M-S-Tab>', ':FloatermPrev<CR>', { silent = true })
    vim.keymap.set('t', '<M-S-Tab>', '<C-\\><C-n>:FloatermPrev<CR>', { silent = true })
    vim.keymap.set('n', '<M-\\>', ':FloatermNew<CR>', { silent = true })
    vim.keymap.set('t', '<M-\\>', '<C-\\><C-n>:FloatermNew<CR>', { silent = true })

    -- FloatermNew --wintype=split --position=botright --height=15
    vim.g.floaterm_wintype = 'split'
    vim.g.floaterm_position = 'botright'
    vim.g.floaterm_height = 15
  end,
}
