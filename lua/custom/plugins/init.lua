-- borrowed from https://www.reddit.com/r/neovim/comments/1j9fy2w/comment/mhec1ru/
vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:12',
  'algorithm:histogram',
  'linematch:200',
  'indent-heuristic',
  'iwhite', -- they toggle this one, it doesn't fit all cases.
}

vim.keymap.set('n', '<C-c>', function()
  vim.cmd 'startinsert'
end, { noremap = true, silent = true })

-- redo last command
vim.keymap.set('n', '<M-.>', ':normal! @:<CR>', { noremap = true, silent = true })

--- Center screen and toggle scrolloff
local orig_scrolloff

local function zzAndToggleScrolloff()
  if orig_scrolloff == nil then
    orig_scrolloff = vim.opt.scrolloff:get()
  end

  vim.cmd 'normal! zz'

  if 9999 == vim.opt.scrolloff:get() then
    vim.notify 'Setting scrolloff to original value'
    vim.opt.scrolloff = orig_scrolloff
    vim.opt.cursorline = true
    -- vim.opt.number = true
    -- vim.opt.relativenumber = true
  else
    vim.notify 'Setting scrolloff to 9999'
    vim.opt.scrolloff = 9999
    vim.opt.cursorline = false
    -- vim.opt.number = false
    -- vim.opt.relativenumber = true
  end
end

vim.keymap.set('n', 'zZ', zzAndToggleScrolloff, { noremap = true })
vim.keymap.set('n', '<Leader>Tc', ':TSContextToggle<CR>', { noremap = true })

vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })
vim.keymap.set('n', '*', '*zz', { noremap = true })
vim.keymap.set('n', '#', '#zz', { noremap = true })
vim.keymap.set('n', 'g*', 'g*zz', { noremap = true })
vim.keymap.set('n', 'g#', 'g#zz', { noremap = true })

vim.opt.guicursor:append 'ci-ve:block' -- Block cursor in command-line and replace modes
vim.opt.wrap = false -- Disable line wrapping

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    config = function()
      vim.opt.spelllang = { 'en', 'programming' }
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }

      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'virtual',
      enable_named_colors = true,
    },
  },
}
