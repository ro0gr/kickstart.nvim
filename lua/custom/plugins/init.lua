vim.cmd 'cab Q q'
vim.cmd 'cab W w'
vim.cmd 'cab Wq wq'
vim.cmd 'cab Qa qa'
vim.cmd 'cab git Git'
vim.cmd 'cab g Git'

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

  'nvim-treesitter/nvim-treesitter-context',

  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      -- Your setup opts here
    },
  },

  {
    'brenoprata10/nvim-highlight-colors',
    opts = {
      render = 'virtual',
      enable_named_colors = true,
    },
  },

  {
    'chrishrb/gx.nvim',
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    cmd = { 'Browse' },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true, -- default settings
  },

  {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'github/copilot.vim',
    config = function()
      vim.keymap.set('i', '<M-S-W>', '<Plug>(copilot-accept-word)')
    end,
  },

  {
    'b0o/SchemaStore.nvim',
    opts = {},
    config = function()
      require('lspconfig').jsonls.setup {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
}
