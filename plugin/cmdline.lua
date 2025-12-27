-- `:` requires a shift key which often leads the first command latter to be uppercase,
-- like `:Wq` instead of `:wq`, which is super annoying.
--
-- see: https://stackoverflow.com/a/42904431/1879162
vim.api.nvim_set_keymap('n', '<Space>', ':', { noremap = true })
vim.api.nvim_set_keymap('v', '<Space>', ':', { noremap = true })

--
-- Unsure whether it's ghostty related, but cursor gets barely visible in when I navigate in cmdline mode
-- so making it block to be more visible
vim.opt.guicursor:append 'ci-ve:block'

-- make sure that :find and gf search in subdirectories
vim.opt.path = '.,**'

-- Enhanced command-line completion
vim.opt.wildoptions:append 'fuzzy'
vim.opt.wildmode = 'noselect:lastused,full'
vim.opt.pumborder = 'rounded'
