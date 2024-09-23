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
    'hoob3rt/lualine.nvim',
    event = 'VimEnter',
    config = function()
      require('lualine').setup {
        -- extensions = { 'fugitive', 'oil', 'quickfix' },
        extensions = { 'fugitive', 'quickfix' },

        sections = {
          lualine_b = {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
            end,

            'branch',
            'diff',
            'diagnostics',
          },
        },
      }
    end,
  },

  {
    'psliwka/vim-dirtytalk',
    build = ':DirtytalkUpdate',
    config = function()
      vim.opt.spelllang = { 'en', 'programming' }
    end,
  },

  -- alternatives:
  --  + also https://github.com/TaDaa/vimade
  { 'miversen33/sunglasses.nvim', opts = {
    filter_type = 'TINT',
    filter_percent = 0.05,
  }, config = true },

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
    'mawkler/demicolon.nvim',
    -- keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' }, -- Uncomment this to lazy load
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {},
  },

}
