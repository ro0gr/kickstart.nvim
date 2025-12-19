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

vim.keymap.set('n', '<Leader>Tc', ':TSContextToggle<CR>', { noremap = true })

vim.opt.wrap = false -- Disable line wrapping

-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
}
