vim.cmd 'cab tq tabclose'
vim.cmd 'cab te tabedit %:p:h'
vim.cmd 'cab tw tabedit $PWD'
vim.cmd 'cab tm tabmove'

vim.keymap.set({ 'n' }, '<M-1>', '1gt', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<M-2>', '2gt', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<M-3>', '3gt', { noremap = true, silent = true })
vim.keymap.set({ 'n' }, '<M-4>', ':tablast<CR>', { noremap = true, silent = true })

-- Terminal mode mappings
vim.keymap.set({ 't', 'i' }, '<M-1>', '<C-\\><C-n>1gt', { noremap = true, silent = true })
vim.keymap.set({ 't', 'i' }, '<M-2>', '<C-\\><C-n>2gt', { noremap = true, silent = true })
vim.keymap.set({ 't', 'i' }, '<M-3>', '<C-\\><C-n>3gt', { noremap = true, silent = true })
vim.keymap.set({ 't', 'i' }, '<M-4>', '<C-\\><C-n>:tablast<CR>', { noremap = true, silent = true })
