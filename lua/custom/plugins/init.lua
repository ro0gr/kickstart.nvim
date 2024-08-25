vim.cmd 'cab Q q'
vim.cmd 'cab W w'
vim.cmd 'cab Wq wq'
vim.cmd 'cab Qa qa'
vim.cmd 'cab git Git'
vim.cmd 'cab g Git'

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'extra customizations for terminal buffers',
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Highlight current line only on focused window
vim.api.nvim_create_autocmd('WinLeave', {
  desc = 'Hide cursor line when leaving window',
  callback = function()
    vim.opt.cursorline = false
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  desc = 'Display cursor line when entering window',
  callback = function()
    vim.opt.cursorline = true
  end,
})

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nanozuki/tabby.nvim',
    -- event = 'VimEnter', -- if you want lazy load, see below
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('tabby').setup()
    end,
  },
  {
    'olrtg/nvim-emmet',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },
  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    config = function()
      vim.opt.spelllang = { 'en', 'programming' }
    end,
  },

  { 'miversen33/sunglasses.nvim', opts = {
    filter_type = 'TINT',
    filter_percent = 0.05,
  }, config = true },
}
