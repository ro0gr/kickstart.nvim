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
vim.opt.wildcharm = vim.fn.char2nr '\t'
vim.opt.pumborder = 'rounded'
vim.opt.pumheight = 10

-- Unfortunately, neovim currently doesn't support opening cmdline in splits or new tabs directly,
--- for built-in commands like :find or custom commands.
--- But I still need a general way to open cmdline in different standard targets (vsplit, split, tabnew).
local function setup_open_target_keymap(key, open_cmd, desc)
  vim.keymap.set('c', key, function()
    -- if vim.fn.pumvisible() == 1 then
    local cmdline = vim.fn.getcmdline()
    vim.schedule(function()
      vim.cmd(open_cmd)
      vim.cmd(cmdline)
    end)
    return '<C-c>'
    -- end
    -- return key
  end, { expr = true, noremap = true, desc = desc })
end

setup_open_target_keymap('<C-V>', 'vsplit', 'Open command line result in vertical split when pum is visible')
setup_open_target_keymap('<C-S>', 'split', 'Open command line result in horizontal split when pum is visible')
setup_open_target_keymap('<C-T>', 'tabnew', 'Open command line result in new tab when pum is visible')

vim.o.cmdheight = 0
vim.pack.add { 'https://github.com/rachartier/tiny-cmdline.nvim' }
