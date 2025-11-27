vim.cmd 'cab tq tabclose'
vim.cmd 'cab te tabedit %:p:h'
vim.cmd 'cab tw tabedit $PWD'
vim.cmd 'cab tm tabmove'

vim.keymap.set({ 'n', 'i', 't' }, '<M-1>', '1gt', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i', 't' }, '<M-2>', '2gt', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i', 't' }, '<M-3>', '3gt', { noremap = true, silent = true })
