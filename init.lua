--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 0

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

vim.o.spell = true
vim.o.spelloptions = 'noplainbuffer,camel'
vim.o.swapfile = false
-- make sure window opacity works
vim.opt.termguicolors = true

vim.opt.laststatus = 3

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldminlines = 1
vim.opt.foldnestmax = 10
-- vim.opt.foldenable = false

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- autocomplete
vim.o.autocomplete = false
vim.o.complete = 'o,.,w,b,u'
vim.opt.completeopt = 'fuzzy,popup,noselect,menuone,preview'

vim.keymap.set('n', '<M-->', '<CMD>e %:p:h<CR>', { desc = 'Open parent directory' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

----- Node.js host configuration -----
local function get_node_handle()
  local handle = io.popen 'cd $HOME && asdf which node 2>/dev/null || which node'
  if handle == nil then
    print 'Warning: Could not open a shell to detect Node.js path. Plugins requiring Node.js may not work.'
    return
  end

  local node_path = handle:read('*a'):gsub('\n', '')
  handle:close()
  return node_path
end

local node_path = get_node_handle()
if node_path ~= '' then
  vim.g.node_host_prog = node_path
else
  print 'Warning: Could not detect Node.js path. Plugins requiring Node.js may not work.'
end

--- Terminal title configuration ---
vim.o.title = true
require('utils.title').setup()

-- misc plugins

vim.pack.add {
  'https://github.com/f-person/auto-dark-mode.nvim',
}
require('auto-dark-mode').setup {}

vim.pack.add {
  'https://github.com/kylechui/nvim-surround',
}
require('nvim-surround').setup {}

vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
}
require('treesitter-context').setup {}

vim.pack.add {
  'https://github.com/stevearc/quicker.nvim',
}
require('quicker').setup {}
